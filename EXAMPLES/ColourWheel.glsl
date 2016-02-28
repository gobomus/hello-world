//*****************************************************************************/
//
// Filename: ColourWheel.glsl
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

// Forward declaration of API function. This is necessary to use in Matchbox otherwise it won't compiled. Please see MatchboxAPI for more info.
vec3  adsk_hsv2rgb( vec3 hsv );
float adsk_getLuminance( vec3 );


// This is the vec3 used to create a colour wheel widget
uniform vec3 colourWheel;

uniform sampler2D front;
uniform float adsk_result_w, adsk_result_h;

// We are using this function to map the Hue and Gain of the Colour Wheel in HSV to an RGB value
vec3 getRGB( float hue )
{
   return adsk_hsv2rgb( vec3( hue, 1.0, 1.0 ) ); }

void main()
{

   vec2 coords = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
   vec3 source = texture2D(front, coords).rgb;
   
   // We used the function detailed above to get our RGB Offset value
   vec3 offset = getRGB( colourWheel.x / 360.0 ) * vec3( colourWheel.y * 0.01);
   
   // Here we are applying the Offset to the Source
   vec3 dest = source + offset; 
   
   // Here we insure that we preserve the Luminance of the image
   dest = dest * vec3(adsk_getLuminance( source ) / max(adsk_getLuminance( dest ), 0.001));
   
   // Here we are using the third Colour Wheel numeric field as a mix parameter, but you could do different thing like adjusting the Saturation
   gl_FragColor = vec4(mix ( source, dest, colourWheel.z * 0.01), 1.0);
   
}
