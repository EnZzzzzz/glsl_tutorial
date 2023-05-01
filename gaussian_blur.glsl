#iChannel0 "/Users/enze/Pictures/1.jpg"

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    uv.y *= iChannelResolution[0].x / iChannelResolution[0].y;

    vec4 col = texture(iChannel0, uv);

    // Output to screen
    fragColor = col;
}