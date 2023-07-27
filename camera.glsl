// "ShaderToy Tutorial - Simplest 3D" 
// by Martijn Steinrucken aka BigWings/CountFrolic - 2017
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
//
// This shader is part of a tutorial on YouTube
// https://www.youtube.com/watch?v=dKA5ZVALOhs


void mainImage(out vec4 fragColor, in vec2 fragCoord)
{

    vec2 uv = fragCoord.xy / iResolution.xy;
    uv -= .5;
    uv.x *= iResolution.x / iResolution.y;

    // Ray origin，表示相机坐标
    vec3 ro = vec3(0., 0., -2.); // 屏幕外

    fragColor = vec4(uv, .5 + .5*sin(iGlobalTime), 1.0);
}