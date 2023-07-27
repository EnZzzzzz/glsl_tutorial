float DistLine(vec3 ro, vec3 rd, vec3 p){
    return length(cross(p-ro, rd)) / length(rd);
}


void mainImage(out vec4 fragColor, in vec2 fragCoord)
{

    vec2 uv = fragCoord.xy / iResolution.xy;
    uv -= .5;
    uv.x *= iResolution.x / iResolution.y;

    // Ray origin，表示相机坐标
    vec3 ro = vec3(0., 0., -2.); // 屏幕外

    // Ray direction
    vec3 rd = vec3(uv.x, uv.y, 0.)-ro;

    float t = iGlobalTime;

    vec3 p = vec3(0.5 * sin(t), 0., 3.+cos(t));
    float d = DistLine(ro, rd, p);


    d = smoothstep(.1, .09, d);

    fragColor = vec4(d);
}