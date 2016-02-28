//*****************************************************************************/
// 
// Filename: ImageRotation.1.glsl
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

uniform float adsk_result_w, adsk_result_h, adsk_result_frameratio;
uniform sampler2D front, matte;
uniform float rotation;

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
   
   //We set the Front RGB as a vec3 and the Matte as a single float channel.
   vec3  frontColor = vec3(0.0);
   float matteColor = 0.0;
   
   
   //This is the rotation matrix that uses the rotation numeric field as input. We negate the rotation value to keep the same rotation direction as in 2D Transform or Action.
   mat2 rotationMatrice = mat2( cos(-rotation), -sin(-rotation), 
                          sin(-rotation), cos(-rotation) );

   //We put the frame ratio into a float, so we can keep the frame ratio when applying the rotation and so it doesn't get squished into the 0,1 boundaries.		  
   float frameRatio = adsk_result_frameratio;   			  
   
   //We remove 0.5 from the coords to apply the rotation.
   coords -= vec2(0.5);
   
   //We multiply the X value by the frame ratio before applying the rotation.
   coords.x *= frameRatio;
   
   //We apply the rotation
   coords *= rotationMatrice;

   //We divide the X value by the frame ratio after applying the rotation.
   coords.x /= frameRatio;
   
   //We add the 0.5 we substracted back to the coords before applying the rotation.
   coords += vec2(0.5);
 
 
   // This is the condition allowing us to apply the black pixels when we will sample the texture
   // Remove this if you want to use the OpenGL repeat mode instead.
   if ( isInTex( coords ) )
   {
 
      //We apply the position transformation to the Front input which is a vec3 for the 3 RGB channels.
      frontColor  = texture2D(front, coords).rgb;
   
      //We apply the position transformation to the Matte input which is a float since we're only using the b(blue) channel that will then be used the in the final output alpha channel.
      matteColor  = texture2D(matte, coords).b;
   
   }

   //Here we combine the front RGB channels and the Matte blue channel into a vec4 RGBA output
   gl_FragColor = vec4(frontColor, matteColor);
}
