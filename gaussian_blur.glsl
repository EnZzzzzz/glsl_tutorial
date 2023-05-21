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
    uv -= .5;
    float d = length(uv);

    vec4 irisCol = vec4(.3, .5, 1., 1.);
    vec4 col = mix(vec4(1.), irisCol, S(.1, .7, d) * .5);

    col.rgb *= 1. - S(.45, .5, d) * .5 * sat(-uv.y-uv.x); // make shadow

    col.rgb = mix(col.rgb, vec3(0.), S(.3, .28, d));

    irisCol.rgb *= 1.  + S(.3, .05, d);
    col.rgb = mix(col.rgb, irisCol.rgb, S(.28, .25, d));

    col.rgb = mix(col.rgb, vec3(0.), S(.16, .14, d));

    float hightlight = S(.1, .09, length(uv - vec2(-.15, .15)));
    hightlight += S(.07, .05, length(uv + vec2(-.08, .08)));
    col.rgb = mix(col.rgb, vec3(1.), hightlight);

    col.a = S(.5, .48, d);

    return col;
}

vec4 Smiely(vec2 uv)
{
    vec4 col = vec4(0.);

    uv.x = abs(uv.x);
    vec4 head = Head(uv);
    vec4 eye = Eye(within(uv, vec4(.03, -.1, .37, .25)));


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
    vec4 smiely = Smiely(uv);

    // Output to screen
    fragColor = smiely;
}