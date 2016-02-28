//*****************************************************************************/
//
// Filename: MatchboxAPI.glsl
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

// For each API provided function you used in your shader you will need to first forward delare them using the syntax below.
// This is very important since your shader won't compile if not done.
vec3  adsk_scene2log( vec3 lin );
vec3  adsk_log2scene( vec3 log );
vec3  adsk_rgb2hsv( vec3 rgb );
vec3  adsk_hsv2rgb( vec3 hsv );
float adsk_getLuminance( vec3 rgb );
vec4  adskEvalDynCurves( ivec4 curve, vec4 x );
vec3  adskEvalDynCurves( ivec3 curve, vec3 x );
vec2  adskEvalDynCurves( ivec2 curve, vec2 x );
float adskEvalDynCurves( int curve, float x );
float adsk_highlights( float lum, float numeric );
float adsk_shadows( float lum, float numeric );
vec4 adsk_getBlendedValue( int blendType, vec4 srcColor, vec4 dstColor );

uniform sampler2D front;
uniform float adsk_result_w, adsk_result_h;
uniform int blendModes;

// To eliminate code duplication we have added a few API function calls that can be used in any Matchbox and Lightbox shaders
// Here are a few examples of what is now possible to use in Flame 2016

void main()
{

   vec2 coords = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
   vec3 source = texture2D(front, coords).rgb;
   
   // These 2 API functions calls allows you to convert vec3 into log space and back to lin space or vice versa
   vec3 sourceLog = adsk_scene2log( source );
   source    = adsk_log2scene( sourceLog );
   
   // These 2 API functions calls allows you to convert vec3 into HSV space and back to RGB
   vec3 sourceHSV = adsk_rgb2hsv( source );
   source    = adsk_hsv2rgb( sourceHSV );
   

   // Here are 3 API functions calls that will allow you to extract Luminance from a vec3 and then define Shadows, Midtones and Highlights transient points
   // These are commented out since no corresponding numeric field was created. Please take a look at the Curves example for a in context usage.
   
   // This function allows to extract luminance value from any vec3
   float L = adsk_getLuminance( source );
   // In this example wL will define the Shadows mid point based on the adskUID_LowMidpoint value, but this could be also hard coded if needed
   //float wL = adsk_shadows( L, LowMidpoint );
   // In this example wH will define the Highlights mid point based on the adskUID_HighMidpoint value, but this could be also hard coded if needed
   //float wH = adsk_highlights( L, HighMidpoint );
   // From wL and wH values we can deduct wM which will be the Midtones range
   //float wM = 1.0 - wL - wH; 
   
   // When using curve widget you will need to use the following function to evaluate the curve and get the result back
   // These are commented out since no corresponding widget was created
   
   //vec4  gain=adskEvalDynCurves( Curves.rgba, vec4(value) );
   //vec3  gain=adskEvalDynCurves( Curves.rgb, vec3(value) );
   //vec2  gain=adskEvalDynCurves( Curves.rg, vec2(value) );
   //float gain=adskEvalDynCurves( Curve.r, value );
 
   vec3 result = source;
   
   
   // Here is how you will use the provided blend modes API
   // Since the function is expecting RGBA input I added a white alpha to both vec3 to make vec4 out of them
   // The blendModes refer to the table below, see the XML for more info
   result = adsk_getBlendedValue( blendModes, vec4 (source, 1.0), vec4 (result, 1.0)).rgb;
   
   gl_FragColor =  vec4(result, 1.0); 
}




// Here are Matchbox API available function calls

//------------------------------------------------------------------------------
// Colour Management
//------------------------------------------------------------------------------
float adskEvalDynCurves(in int dynCurveId, in float x);
vec2 adskEvalDynCurves(in ivec2 dynCurveId, in vec2 x);
vec3 adskEvalDynCurves(in ivec3 dynCurveId, in vec3 x);
vec4 adskEvalDynCurves(in ivec4 dynCurveId, in vec4 x);
 
// Conversions between scene linear and Cineon log colour space
vec3 adsk_scene2log( in vec3 src );
vec3 adsk_log2scene( in vec3 src );
 
// Conversions between RGB and HSV, YUV
vec3 adsk_rgb2hsv( in vec3 c );
vec3 adsk_hsv2rgb( in vec3 c );
vec3 adsk_rgb2yuv( in vec3 c );
vec3 adsk_yuv2rgb( in vec3 c );
 
 
vec3 adsk_getLuminanceWeights();
float adsk_getLuminance( in vec3 color );
 
// Parametric blending curves suitable for blending effects for Shadows, Midtones, Highlights. 
// The first argument is the pixel colour. Second argument is the X-axis location, 
// where the curve is 50% . To get the midtone weight, you need to compute 
// 1 - adsk_shadows - adsk_highlights, for the same pixel colour
float adsk_highlights( in float pixel, in float halfPoint );
float adsk_shadows( in float pixel, in float halfPoint );
//------------------------------------------------------------------------------
// Blending
//------------------------------------------------------------------------------
//    Add            = 0,   Sub            = 1,   Mul             = 2,
//    LinearBurn     = 10,  Spotlight      = 11,  Flame_SoftLight = 13,
//    HardLight      = 14,  PinLight       = 15,  Screen          = 17,
//    Overlay        = 18,  Diff           = 19,  Exclusion       = 20,
//    Flame_Max      = 29,  Flame_Min      = 30,  LinearLight     = 32,
//    LighterColor   = 33,
vec4 adsk_getBlendedValue( int blendType, vec4 srcColor, vec4 dstColor );
