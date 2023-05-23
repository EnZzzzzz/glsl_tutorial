#define S(a, b, t) smoothstep(a, b, t)
#define sat(x) clamp(x, 0., 1.)

float remap01(float a, float b, float t)
{
    return sat((t - a) / (b - a));
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
   
    vec2 uv = fragCoord/iResolution.xy;
    uv -= .5;    
    // uv.x *= iResolution.x / iResolution.y;

    float y = uv.y;

    uv.y += uv.x * .8;
    uv.y += .1;
    
   
    vec4 col = vec4(0.);
    vec4 cir = vec4(0.9, .65, .1, 1.);

    float blur = .01;
    float d = length(uv);
    float s = S(.45, .45 - blur, d);
    float d1 = length(uv + vec2(-0.05, 0.2));
    float s1 = S(.5, .5 - blur, d1);

    float hightlight = remap01(.31, 0.41, y);
    hightlight *= S( .42, .41, d);

    cir.rgb = mix(cir.rgb, vec3(1.), hightlight);

    cir.a = sat(s - s1);
    // cir.a = s;
    
    col = mix(col, cir, cir.a);
    fragColor = col;
}