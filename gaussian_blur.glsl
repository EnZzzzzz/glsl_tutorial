#define S(a, b, t) smoothstep(a, b, t)
#define sat(x) clamp(x, 0., 1.)


float remap01(float a, float b, float t)
{

    return sat((t - a) / (b - a));
}

float remap(float a, float b, float c, float d, float t)
{
    return remap01(a, b, t) * (d - c) + c;
}

vec2 within(vec2 uv, vec4 rect)
{
    return (uv - rect.xy) / (rect.zw - rect.xy);
}

vec4 new(vec2 uv)
{
    vec4 col = vec4(0.);

    return col;
}

vec4 Head(vec2 uv)
{
    vec4 col = vec4(0.9, .65, .1, 1.);
    float d  = length(uv);

    col.a = S(.5, .49, d);

    float edgeShape = remap01(.35, .5, d);
    edgeShape *= .75;
    edgeShape *= edgeShape;

    col.rgb *=  1. - edgeShape;
    col.rgb = mix(col.rgb, vec3(.6, .3, .1), S(.47, .48, d));

    float hightlight = S(.41, .405, d);
    hightlight *= remap(.41, -.1, .75, .0, uv.y);
    col.rgb = mix(col.rgb, vec3(1.), hightlight);

    d = length(uv - vec2(.25, -.2));
    float cheek = S(.2, .01, d) * .4;
    cheek *= S(.18, .16, d); // make edge sharper
    col.rgb = mix(col.rgb, vec3(1., .1, .1), cheek);

    return col;
}

vec4 Eye(vec2 uv)
{
    vec4 col = vec4(0.);

    return col;
}

vec4 Smiely(vec2 uv)
{
    vec4 col = vec4(0.);

    uv.x = abs(uv.x);
    vec4 head = Head(uv);
    vec4 eye = Eye(uv);


    col = mix(col, head, head.a);
    col = mix(col, eye, eye.a);

    return col;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    uv -= .5;
    uv.x *= iResolution.x / iResolution.y;

    // Time varying pixel color
    vec4 col = vec4(0., 0., 0., 1.);

    vec4 smiely = Smiely(uv);
    col.rgb = mix(col.rgb, smiely.rgb, smiely.a);

    // Output to screen
    fragColor = col;
}