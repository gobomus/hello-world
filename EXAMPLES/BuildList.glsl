//*****************************************************************************/
// 
// Filename: BuildList.glsl
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

// This shaders is an example of how an integer uniform can be transformed into a List (Popup button). 
// The transformation is not made in this .glsl file, but in the associated .xml file.

uniform int Colour;

void main()
{
   if( Colour ==0)
      gl_FragColor = vec4(1,0,0,0);
   else if ( Colour == 1)
      gl_FragColor = vec4(0,1,0,0);
   else if ( Colour == 2)
      gl_FragColor = vec4(0,0,1,0);
   else
      gl_FragColor = vec4(0);
}
