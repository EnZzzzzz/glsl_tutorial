float DistLine(vec3 ro, vec3 rd, vec3 p)
{
    return length(cross(p - ro, rd)) / length(rd);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{

    vec2 uv = fragCoord.xy / iResolution.xy;
    uv -= .5;
    uv.x *= iResolution.x / iResolution.y;

    // z值如果为负数，表示camera在屏幕外面，为正时表示camera在屏幕里面
    // ro表示的camera的坐标
    vec3 ro = vec3(0., 0., -2.);

    // rd表示屏幕上一点I的向量
    // rd=I-ro
    vec3 rd = vec3(uv, 0.) - ro;

    float t = iGlobalTime;


    vec3 p = vec3(sin(t) * 0.5, 0., 2. + cos(t) * 2.);
    float d = DistLine(ro, rd, p);

    d = smoothstep(.1, .09, d);

    fragColor = vec4(d);
}