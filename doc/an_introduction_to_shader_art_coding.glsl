
vec3 palette(in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d){
    return a + b*cos(3.1415926 * 2. * (c*t+d));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord){

    // vec2 uv = fragCoord / iResolution.xy * 2.0 - 1.0;
    // uv.x *= iResolution.x / iResolution.y;
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    vec2 uv0  = uv;
    vec3 finalColor = vec3(0.);

    vec3 col_a = vec3(0.5, 0.5, 0.5);
    vec3 col_b = vec3(0.5, 0.5, 0.5);
    vec3 col_c = vec3(1.0, 1.0, 1.0);
    vec3 col_d = vec3(0.263, 0.416, 0.557);

    for (float i=0.0; i < 4.0; i++){
        uv = fract(uv * 1.5) - 0.5;

        float d = length(uv) * exp(-length(uv0));

        vec3 col = palette(length(uv0) + i * .4 + iTime * 0.4, col_a, col_b, col_c, col_d);

        d = sin(d * 8.0 + iTime) / 8.0;
        d = abs(d);

        d = 0.01 / d;
        d = pow(d, 1.2);

        finalColor += col * d;
    }
    fragColor = vec4(finalColor, 1.0);
}