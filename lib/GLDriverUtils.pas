unit GLDriverUtils;

interface
  uses sgTypes, sgShared;
  


  procedure FloatColors(c: Color; var r, g, b, a: Single);

  // Return a power of 2 that is greater than or equal to v.
  function Pow2GEQ(v: Longint) : Longint;

  procedure RenderTexture(tex: Cardinal; ratioX, ratioY, ratioW, ratioH : Single; const destRect : RectPtr); 
  procedure SetColor(clr : Color);

implementation
  uses {$IFDEF IOS}gles11 {$ELSE}gl{$ENDIF}, sgDriverGraphics;

  procedure SetColor(clr : Color);
  var
    r,g,b,a : Byte;
  begin
    GraphicsDriver.ColorComponents(clr,r,g,b,a);
    glColor4f(r/255, g/255, b/255, a/255);
  end;

  procedure FloatColors(c: Color; var r, g, b, a: Single);
  begin
    // writeln(c, ' = ', IntToHex(c, 8));
    // writeln(IntToHex(c and $FF000000, 8), ' -> ', IntToHex((c and $FF000000) shr 24, 8));
    a := (c and $FF000000 shr 24) / 255;
    r := (c and $00FF0000 shr 16) / 255;
    g := (c and $0000FF00 shr 8) / 255;
    b := (c and $000000FF) / 255;
  end;

  function Pow2GEQ(v: Longint) : Longint;
  begin
    result := 1;
    while result < v do
    begin
      result := result shl 1; // result *= 2
    end;
  end;

  // Render the srcRect part of the tex texture, to the dest rectangle
  procedure RenderTexture(tex: Cardinal; ratioX, ratioY, ratioW, ratioH : Single; const destRect : RectPtr); 
  var
    //lTexture : GLuint;
    textureCoord : Array[0..3] of Point2D;
    vertices : Array[0..3] of Point2D;
  begin
    //set up texture co-ords
    textureCoord[0].x := ratioX;      textureCoord[0].y := ratioY;
    textureCoord[1].x := ratioX;      textureCoord[1].y := ratioH;
    textureCoord[2].x := ratioW;      textureCoord[2].y := ratioY;
    textureCoord[3].x := ratioW;      textureCoord[3].y := ratioH;

    //set up vertices co-ords
    vertices[0].x := destRect^.x;                         vertices[0].y := destRect^.y;
    vertices[1].x := destRect^.x;                         vertices[1].y := destRect^.y + destRect^.height;
    vertices[2].x := destRect^.x + destRect^.width;       vertices[2].y := destRect^.y;
    vertices[3].x := destRect^.x + destRect^.width;       vertices[3].y := destRect^.y + destRect^.height;
    
    //enable vertex and texture array
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);

    glBindTexture( GL_TEXTURE_2D, tex );
    
    glVertexPointer(2, GL_FLOAT, 0, @vertices[0]);
    glTexCoordPointer(2, GL_FLOAT, 0, @textureCoord[0]);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, Length(vertices));
    
    // Finish with texture
    glBindTexture( GL_TEXTURE_2D, 0);
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  end;

end.