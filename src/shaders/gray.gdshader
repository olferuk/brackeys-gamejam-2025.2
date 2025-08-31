shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float tone_mix : hint_range(0.0, 1.0) = 0.0;
uniform bool  use_sepia = false;

uniform float vignette_intensity : hint_range(0.0, 2.0) = 0.8;
uniform float vignette_softness  : hint_range(0.0001, 1.0) = 0.45;
uniform vec2  vignette_center    = vec2(0.5, 0.5);

uniform float animation_len : hint_range(0.0, 30.0) = 0.0;
uniform float start_time    = 0.0;
uniform bool  is_active     = false;

uniform float radial_blur_strength : hint_range(0.0, 0.02) = 0.005;
uniform int   radial_blur_samples  : hint_range(1, 16) = 5;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 src = texture(SCREEN_TEXTURE, uv);
    vec3 col = src.rgb;

    float a = 0.0;
    if (is_active) {
        if (animation_len > 0.0) {
            float lin = clamp((TIME - start_time) / animation_len, 0.0, 1.0);
            a = smoothstep(0.0, 1.0, lin);
        } else {
            a = 1.0;
        }
    }

    if (radial_blur_strength > 0.0 && radial_blur_samples > 1) {
        vec2 dir = uv - vignette_center;
        vec3 acc = col;
        for (int i = 1; i < radial_blur_samples; i++) {
            float t = float(i) / float(radial_blur_samples);
            vec2 offset = dir * radial_blur_strength * t * a;
            acc += texture(SCREEN_TEXTURE, clamp(uv - offset, 0.0, 1.0)).rgb;
        }
        col = acc / float(radial_blur_samples);
    }

    float tone_mix_eff = tone_mix * a;
    float vig_int_eff  = vignette_intensity * a;

    float luma = dot(col, vec3(0.299, 0.587, 0.114));
    vec3 gray  = vec3(luma);

    vec3 sepia;
    sepia.r = dot(col, vec3(0.393, 0.769, 0.189));
    sepia.g = dot(col, vec3(0.349, 0.686, 0.168));
    sepia.b = dot(col, vec3(0.272, 0.534, 0.131));

    vec3 target = use_sepia ? sepia : gray;
    col = mix(col, target, tone_mix_eff);

    vec2 p = uv - vignette_center;
    float aspect = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
    p.x *= aspect;

    float dist = length(p);
    float edge = smoothstep(1.0 - vignette_softness, 1.0, dist);
    float vig  = mix(1.0, 1.0 - vig_int_eff, edge);
    col *= clamp(vig, 0.0, 1.0);

    COLOR = vec4(col, src.a);
}
