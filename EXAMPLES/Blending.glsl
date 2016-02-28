//*****************************************************************************/
// 
// Filename: Blending.glsl
//
// Copyright (c) 2011 Autodesk, Inc.
// All rights reserved.
// 
// This computer source code and related instructions and comments are the
// unpublished confidential and proprietary information of Autodesk, Inc.
// and are protected under applicable copyright and trade secret law.
// They may not be disclosed to, copied or used by any third party without
// the prior written consent of Autodesk, Inc.
//*****************************************************************************/

// This shader is an example of how two clips can be blended together.
// The result of the following code is equivalent to an Add operation.

uniform sampler2D input1, input2;
uniform float adsk_result_w, adsk_result_h;
uniform int blendMode;

vec4 adsk_getBlendedValue( int blendType, vec4 srcColor, vec4 dstColor );

void main()
{
   vec2 coords = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
   vec3 sourceColor1 = texture2D(input1, coords).rgb;
   vec3 sourceColor2 = texture2D(input2, coords).rgb;

   vec4 blendedColor = adsk_getBlendedValue(
      blendMode, vec4( sourceColor1, 1.0 ), vec4( sourceColor2, 1.0 )
   );

   gl_FragColor = vec4( blendedColor.rgb, 1.0 );
}
