//*****************************************************************************/
// 
// Filename: TransitionShader.01.glsl
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
uniform sampler2D front1, front2, matte1, matte2;
uniform float transp;

// The first shader pass allows to basically do a dissolve in between both RGBA inputs of the transition, then you can apply any 
// effects in the following passes on top of that dissolve transition. In this example we are doing a blur. For effects where not 
// applied of the sum the Incoming/Outgoing inputs, then the strategy could be different and the code be put directly in the same 
// pass.

void main()
{
   vec2 coords = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
   vec4 front1Color = vec4( texture2D(front1, coords).rgb,
                            texture2D(matte1, coords).b );
   vec4 front2Color = vec4( texture2D(front2, coords).rgb,
                            texture2D(matte2, coords).b );
   
   // transp is the mix value you will have in the UI to mix both inputs together.
   gl_FragColor = vec4( mix(front2Color.rgba, front1Color.rgba, transp));
}
