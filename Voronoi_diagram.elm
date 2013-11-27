import Random
import Signal
import Window
import Mouse

--Manhattan Distance function
dist (x1,y1) (x2,y2) = abs (x1-x2) + abs (y1-y2)

region (xdim,ydim) sites current =
  let compsites = filter (\r -> r /= current) sites
      space = foldr (\x base -> (map (\y -> (x,y)) [0..ydim]) ++ base) []
        [0..xdim]
  in filter (\point -> foldl (&&) True 
             <| map (\s -> dist point current <= dist point s) compsites) space
             
drawCircles color (x,y) =
  ngon 8 2   |> filled color
             |> rotate (degrees 22.5)
             |> move (x,y)

mkcircles (x,y) cindex space =
  let angle = degrees (163 * toFloat cindex)
      color = (hsv angle 1 1)
  in group <| map (drawCircles color) space
 
scene (w',h') (mx,my) = 
  let xdim = 50
      scaleFactor = (toFloat w') / (toFloat xdim)
      ydim = (toFloat xdim) * (toFloat h') / (toFloat w')
      mousePosition = ((toFloat mx) / scaleFactor,((toFloat (h' - my)) / scaleFactor))
      pset = mousePosition :: [(40,10),(10,40),(0,30),(10,10),(20,30)]
      regen (epicenter,number) = scale scaleFactor
                              <| move (-1 * toFloat w' /2,-1 * toFloat h'/2)
                              <| mkcircles epicenter number (region (xdim,ydim) pset epicenter)
  in collage w' h' <| ((zip pset [1..20]) |> map regen)
                    


main = lift2 scene Window.dimensions Mouse.position