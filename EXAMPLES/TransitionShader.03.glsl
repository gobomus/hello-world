//*****************************************************************************/
// 
// Filename: TransitionShader.03.glsl
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

uniform sampler2D adsk_results_pass2;
uniform float adsk_result_w, adsk_result_h;
uniform vec2 blurAmount;
uniform bool propBlur;
uniform float propBlurAmount;

//Here we take the output of the second pass which is the X blur and apply the Y blur and this give us the final result of our transition.

void main()
{
   vec2 coords = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
   float blurValue = propBlur ? propBlurAmount : blurAmount.y;
   int intPart = int( blurValue );
   vec4 accu = vec4(0);
   float energy = 0.0;
   float matteEnergy = 0.0;
   vec4 finalColor = vec4(0.0);
   
   for( int y = -intPart; y <= intPart; y++)
   {
      vec2 currentCoord = vec2(coords.x, coords.y+float(y)/adsk_result_h);
      vec4 aSample = texture2D(adsk_results_pass2, currentCoord);
      float anEnergy = 1.0 - ( abs(float(y)) / blurValue );
      energy += anEnergy;
      accu += aSample * anEnergy;
   }
   
   finalColor = 
      energy > 0.0 ? (accu / energy) : texture2D(adsk_results_pass2, coords);
                     
   gl_FragColor = finalColor;
}
