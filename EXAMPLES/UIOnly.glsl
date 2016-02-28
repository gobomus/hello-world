//*****************************************************************************/
// 
// Filename: UIOnly.glsl
//
// Copyright (c) 2014 Autodesk, Inc.
// All rights reserved.
// 
// This computer source code and related instructions and comments are the
// unpublished confidential and proprietary information of Autodesk, Inc.
// and are protected under applicable copyright and trade secret law.
// They may not be disclosed to, copied or used by any third party without
// the prior written consent of Autodesk, Inc.
//*****************************************************************************/

//For UI only shaders you do not need to define anything in the .glsl file
void main(void)
{
   gl_FragColor.rgba = vec4( 0.0 );
}
