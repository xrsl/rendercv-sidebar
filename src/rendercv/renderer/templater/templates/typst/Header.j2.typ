{% macro image() %}
#pad(left: {{ design.header.photo_space_left }}, right: {{ design.header.photo_space_right }}, image("{{ cv.photo.name }}", width: {{ design.header.photo_width }}))
{% endmacro %}

{% if cv.photo %}
{% set photo = "image(\"" + cv.photo|string + "\", width: "+ design.header.photo_width + ")" %}
#grid(
{% if design.header.photo_position == "left" %}
  columns: (auto, 1fr),
{% else %}
  columns: (1fr, auto),
{% endif %}
  column-gutter: 0cm,
  align: horizon + left,
{% if design.header.photo_position == "left" %}
  [{{ image() }}],
  [
{% else %}
  [
{% endif %}
{% endif %}
{% if cv.expertise_tags %}
#grid(
  columns: (1fr, auto),
  column-gutter: 0.5cm,
  align: (left + top, right + top),
  [
{% endif %}
{% if cv.name %}
= {{ cv.name }}
{% endif %}

{% if cv.headline %}
  #headline([{{ cv.headline }}])

{% endif %}
{% if not cv.expertise_tags %}
#connections(
{% for connection in cv.connections %}
  [{{ connection }}],
{% endfor %}
)
{% endif %}
{% if cv.expertise_tags %}
  ],
  [
    #stack(
      dir: ttb,
      spacing: 0.1em,
{% for tag in cv.expertise_tags %}
      box(fill: {{ design.colors.section_titles.as_rgb() }}, radius: 3pt, inset: 3pt)[#text(size: 9pt, fill: white, weight: "bold")[{{ tag }}]],
{% endfor %}
    )
  ]
)

#connections(
{% for connection in cv.connections %}
  [{{ connection }}],
{% endfor %}
)
{% endif %}
{% if cv.photo %}
{% if design.header.photo_position == "left" %}
  ]
)
{% else %}
  ],
  [{{ image() }}],
)
{% endif %}
{% endif %}
