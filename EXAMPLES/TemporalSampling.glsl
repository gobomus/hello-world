//*****************************************************************************/
// 
// Filename: TemporalSampling.glsl
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

// This shaders provides an example of how you can sample the previous and next frame into a shader.
// This is done using the adsk_previous_frame_input1 and adsk_next_frame_input1 uniforms

uniform sampler2D adsk_previous_frame_input1;
uniform sampler2D adsk_next_frame_input1;
uniform sampler2D input1;
uniform float adsk_result_w, adsk_result_h;

void main(void)
{
   vec2 coords = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
   vec3 prev = texture2D( adsk_previous_frame_input1, coords ).rgb;
   vec3 next = texture2D( adsk_next_frame_input1, coords ).rgb;
   vec3 curr = texture2D( input1, coords ).rgb;
   gl_FragColor = vec4( (prev + next + curr) / 3.0, 1.0 );
}
