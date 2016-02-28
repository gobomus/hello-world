//*****************************************************************************/
// 
// Filename: ImagePosition.1.glsl
//
// Copyright (c) 2013 Autodesk, Inc.
// All rights reserved.
// 
// This computer source code and related instructions and comments are the
// unpublished confidential and proprietary information of Autodesk, Inc.
// and are protected under applicable copyright and trade secret law.
// They may not be disclosed to, copied or used by any third party without
// the prior written consent of Autodesk, Inc.
//*****************************************************************************/

uniform float adsk_result_w, adsk_result_h;
uniform sampler2D front, matte;
uniform vec2 axis;

// This test is to know if we are inside the texture, so we can crop the texture with black instead of being forced to repeat the texture when we reach the texture border.
// This isn't mandatory. If you want the texture to repeat, remove the following and use the appropriate OpenGL repeat mode in the xml.
bool isInTex( const vec2 coords )
{
   return coords.x >= 0.0 && coords.x <= 1.0 &&
          coords.y >= 0.0 && coords.y <= 1.0;
}


void main()
{
   vec2 coords = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
   
   //We set the Front RGB as a vec3 and the Matte as a single float channel
   vec3  frontColor = vec3(0.0);
   float matteColor = 0.0;
   
   //The X and Y position transformation uses the vec2 axis which give us 2 numerics
   vec2 position_coords = (coords-axis) + vec2(0.5);  
 
   // This is the condition allowing us to apply the black pixels when we sample the texture
   // Remove this if you want to use the OpenGL repeat mode instead.
   if ( isInTex( position_coords ) )
   {
 
      //We apply the position transformation to the Front input which is a vec3 for the 3 RGB channels.
      frontColor  = texture2D(front, position_coords).rgb;
   
      //We apply the position transformation to the Matte input which is a float since we're only using the b(blue) channel that will then be used the in the final output alpha channel.
      matteColor  = texture2D(matte, position_coords).b;
   
   }

   //Here we combine the front RGB channels and the Matte blue channel into a vec4 RGBA output
   gl_FragColor = vec4(frontColor, matteColor);
}
