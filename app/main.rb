def tick(args)
  #########################
  #########################
  #########################
  # This code chunk isn't related to the fog effect, it just lets you use arrow keys to move the fog layer around
  # so you can see what it looks like to hide/show the layer below.
  #########################
  #########################
  #########################
    args.state.x ||= 200
    args.state.y ||= 200
    if args.inputs.up
      args.state.y += 10
    elsif args.inputs.down
      args.state.y -= 10
    end

    if args.inputs.left
      args.state.x -= 10
    elsif args.inputs.right
      args.state.x += 10
    end
  #########################

  args.outputs.background_color = [65, 147, 226]  # this is a sharp blue, so you can tell when you're seeing nothing rendered

  # bottom layer is yellow, so you can tell when it's not blue
  args.outputs[:bottom_layer].solids << { x: 0, y: 0, w: args.grid.w, h: args.grid.h, r: 200, g: 200, b: 50,}
  args.outputs[:bottom_layer].labels << { x: 50, y: 50, text: "bottom layer (map/display)",}
  args.outputs[:bottom_layer].borders << {x: 2,y: 2,w: args.grid.w - 4,h: args.grid.h - 4,r: 255,g: 0,b: 0,}
  args.outputs[:bottom_layer].transient!

  # top layer is the "fog" + mask
  # it's a fully black overlay
  # but then anything you put a white element onto, will punch through to underneath thanks to blendmode_enum when being added
  # to `combined` layer.
  args.outputs[:top_layer].background_color = [0,0,0]
  args.outputs[:top_layer].solids << {x: 100,y: 100,w: 50,h: 50,r: 255,g: 255,b: 255,a: 255,    }
  args.outputs[:top_layer].labels << {x: 50,y: 50,text: "top layer (fog + punch-through sprites)",r: 255,g: 255,b: 255,}
  args.outputs[:top_layer].borders << {x: 2,y: 2,w: args.grid.w - 4,h: args.grid.h - 4,r: 0,g: 0,b: 255,}
  args.outputs[:top_layer].transient!

  # bottom layer first
  args.outputs[:combined].sprites << {path: :bottom_layer,x: 0,y: 0,w: args.grid.w,h: args.grid.h,}
  args.outputs[:combined].sprites << {path: :top_layer,x: args.state.x,y: args.state.y,w: args.grid.w,h: args.grid.h,
    blendmode_enum: 4,  # THE IMPORTANT PIECE
  }
  args.outputs[:combined].transient!

  # output the entire combined RT to the screen, `bottom_layer` and `top_layer` are never rendered on their own
  args.outputs.primitives << {primitive_marker: :sprite,path: :combined,x: 0,y: 0,w: args.grid.w,h: args.grid.h}
end