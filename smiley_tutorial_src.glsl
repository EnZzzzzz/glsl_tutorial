#define S(a, b, t) smoothstep(a, b, t)
#define sat(x) clamp(x, 0.0, 1.0)

float remap01(float a, float b, float t)
{
    return sat((t-a) / (b-a));
}

float remap(float a, float b, float c, float d, float t)
{
    return remap01(a, b, t) * (d-c) + c;
}

vec2 within(vec2 uv, vec4 rect)
{
    return (uv - rect.xy) / (rect.zw - rect.xy);
}

vec4 Brow(vec2 uv)
{
    float y = uv.y;
    uv.y += uv.x*0.8-0.3;
    uv.x -= 0.1;
    uv -= 0.5;
    
    vec4 col = vec4(0.0);
    
    float blur = 0.1;
    
    float d1 = length(uv);
    float s1 = S(0.45, 0.45-blur, d1);
    float d2 = length(uv-vec2(0.1, -0.2)*0.7);
    float s2 = S(0.5, 0.5-blur, d2);
    
    float browMask = sat(s1-s2);
    
    float colMask = remap01(0.7, 0.8, y)*0.75;
    colMask *= S(0.6, 0.9, browMask);
    vec4 browCol = mix(vec4(0.4, 0.2, 0.2, 1.0), vec4(1., .75, .5, 1.), colMask);
    
    col = mix(col, vec4(0.0, 0.0, 0.0, 1.0), S(0.0, 1.0, browMask));
    
    col = mix(col, browCol, S(0.2, 0.4, browMask));
    
    return col;
}

vec4 Eye(vec2 uv)
{
    uv -= 0.5;
    float dist = length(uv);
    vec4 irisCol = vec4(0.3, 0.5, 1.0, 1.0);
    vec4 color = mix(vec4(1.0), irisCol, S(0.1, 0.7, dist)*0.5);
    
    color.rgb *= 1.0 - S(0.45, 0.5, dist)*0.5*sat(-uv.y-uv.x);
    color.rgb = mix(color.rgb, vec3(0.0), S(0.3, 0.28, dist)); // iris outline black
    irisCol.rgb *= 1.0 + S(0.3, 0.05, dist);
    
    color.rgb = mix(color.rgb, irisCol.rgb, S(0.28, 0.25, dist));
    color.rgb = mix(color.rgb, vec3(0.0), S(0.16, 0.14, dist));
    
    float highlight = S(0.1, 0.08, length(uv - vec2(-0.15, 0.15)));
    highlight += S(0.07, 0.05, length(uv + vec2(-0.08, 0.08)));
    color.rgb = mix(color.rgb, vec3(1.0), highlight);
    
    color.a = S(0.5, 0.48, dist);
    
    return color;
}

vec4 Mouth(vec2 uv)
{
    uv -= 0.5;
    vec4 color = vec4(0.5, 0.18, 0.05, 1.0);
    
    uv.y *= 1.5;
    uv.y -= uv.x * uv.x * 2.0;
        
    float dist = length(uv);
    
    color.a = S(0.5, 0.48, dist);
    
    float td = length(uv - vec2(0.0, 0.6));
    
    vec3 toothCol = vec3(1.0) * S(0.6, 0.35, dist);
    color.rgb = mix(color.rgb, toothCol, S(0.4, 0.37, td));
    
    td = length(uv+vec2(0.0, 0.5));
    color.rgb = mix(color.rgb, vec3(1.0, 0.5, 0.5), S(0.5, 0.2, td));
    
    return color;
}

vec4 Head(vec2 uv)
{
    vec4 color = vec4(0.9, 0.65, 0.1, 1.0);
    
    float dist = length(uv);
    
    color.a = S(0.5, 0.49, dist);
    
    float edgeShade = remap01(0.35, 0.5, dist);
    edgeShade *= edgeShade;
    
    color.rgb *= 1.0 - edgeShade*0.5;
    
    color.rgb = mix(color.rgb, vec3(0.6, 0.3, 0.1), S(0.47, 0.48, dist));
    
    float highlight = S(0.41, 0.405, dist);
    
    highlight *= remap(0.41, -0.1, 0.75, 0.0, uv.y);
    highlight *= S(0.18, 0.19, length(uv-vec2(0.21, 0.09)));
    color.rgb = mix(color.rgb, vec3(1.0), highlight);
    
    dist = length(uv - vec2(0.25, -0.2));
    float cheek = S(0.2, 0.01, dist)*0.4;
    cheek *= S(0.17, 0.16, dist);
    color.rgb = mix(color.rgb, vec3(1.0, 0.1, 0.1), cheek);
    
    return color;
}

vec4 Smiley(vec2 uv)
{
    vec4 color = vec4(0.0);
    
    uv.x = abs(uv.x);
    vec4 head = Head(uv);
    vec4 eye = Eye(within(uv, vec4(0.03, -0.1, 0.37, 0.25)));
    vec4 mouth = Mouth(within(uv, vec4(-0.3, -0.4, 0.3, -0.1)));
    vec4 brow = Brow(within(uv, vec4(0.03, 0.2, 0.4, 0.43)));
    
    color = mix(color, head, head.a);
    color = mix(color, eye, eye.a);
    color = mix(color, mouth, mouth.a);
    color = mix(color, brow, brow.a);
    
    return color;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

    uv -= 0.5;
    uv.x *= iResolution.x / iResolution.y;

    // Output to screen
    fragColor = Smiley(uv);
}