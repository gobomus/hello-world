//*****************************************************************************/
// 
// Filename: PyramidBlur.1.glsl
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

uniform sampler2D frontTex, matteTex;
uniform float adsk_result_w, adsk_result_h;
uniform vec2 blurAmount;
uniform bool propBlur;
uniform float propBlurAmount;

void main()
{
   vec2 coords = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
   float blurValue = propBlur ? propBlurAmount : blurAmount.x;
   int intPart = int( blurValue );
   vec4 accu = vec4(0);
   float energy = 0.0;
   float matteEnergy = 0.0;
   vec4 finalColor = vec4(0.0);
   
   for( int x = -intPart; x <= intPart; x++)
   {
      vec2 currentCoord = vec2(coords.x+float(x)/adsk_result_w, coords.y);
      vec4 aSample = vec4( vec3(texture2D(frontTex, currentCoord).rgb),
                           texture2D(matteTex, currentCoord).b );
      float anEnergy = 1.0 - ( abs(float(x)) / blurValue );
      energy += anEnergy;
      accu += aSample * anEnergy;
   }
   
   finalColor = 
      energy > 0.0 ? (accu / energy) : 
                     vec4( vec3(texture2D(frontTex, coords).rgb),
                           texture2D(matteTex, coords).b );
                     
   gl_FragColor = finalColor;
}
