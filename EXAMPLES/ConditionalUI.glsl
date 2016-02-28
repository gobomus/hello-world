//*****************************************************************************/
// 
// Filename: ConditionalUI.glsl
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

// This shader is an example of how uniforms can be disabled/hidden based on the status of another uniform.
// The conditions are not set in this .glsl file, but in the associated .xml file.

uniform float adsk_result_w, adsk_result_h, adsk_time;
uniform bool animated;
uniform float speed, blending;
uniform int colour;
uniform float red_gain, green_gain, blue_gain;

float noise(vec2 coords)
{
   return fract(sin(dot(coords.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main()
{
   vec2 coords = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
   float red =   noise( coords * (animated?floor(adsk_time*speed)+1.0:2.0) );
   float green = noise( coords * (animated?floor(adsk_time*speed)+2.0:3.0) );
   float blue =  noise( coords * (animated?floor(adsk_time*speed)+3.0:4.0) );
   float randomValue = noise( coords * (animated?adsk_time*speed+1.0:2.0) );
   
   vec3 rgb = vec3(red, green, blue);
   
   rgb = rgb * vec3(red_gain,green_gain,blue_gain);
   
   rgb = mix(rgb, vec3(1.0), blending);

   if( colour ==0)        
      gl_FragColor = vec4( rgb, 1.0 );
   else if ( colour == 1) 
      gl_FragColor = vec4( vec3(randomValue), 1.0 );
   else if ( colour == 2)
      gl_FragColor = vec4( vec3(rgb.r, 0.0, 0.0), 1.0 );
   else if ( colour == 3) 
      gl_FragColor = vec4( vec3(0.0, rgb.g, 0.0), 1.0 );        
   else if ( colour == 4) 
      gl_FragColor = vec4( vec3(0.0, 0.0, rgb.b), 1.0 );
   else
      gl_FragColor = vec4(0);
}
