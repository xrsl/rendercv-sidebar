# Sidebar Theme Implementation Plan

## Goal
Add 2-column sidebar layout support to rendercv, similar to LaTeX's paracol package.

## Architecture Changes

### 1. Schema Extension (`src/rendercv/schema/models/`)

**New Theme: `sidebar_theme.py`**
- Copy `classic_theme.py` as base
- Add new `Sidebar` class with options:
  ```python
  class Sidebar(BaseModelWithoutExtraKeys):
      width: TypstDimension = "30%"  # Sidebar width
      position: Literal["left", "right"] = "left"
      gutter: TypstDimension = "0.5cm"  # Space between columns
      background_color: Optional[Color] = None
      sections: list[str] = []  # Which sections go in sidebar
  ```

**Modify CV model** to support sidebar section grouping:
- Add `sidebar_sections` field to specify which sections render in sidebar
- Default: `["skills", "publications", "values", "hobbies", "references"]`
- Main sections: `["experience", "education", "honors_and_awards", "courses"]`

### 2. Typst Template Updates

**`Preamble.j2.typ`** - Add 2-column layout setup:
```typst
// After header, start 2-column layout
#grid(
  columns: ({{ design.sidebar.width }}, 1fr),
  gutter: {{ design.sidebar.gutter }},
  [
    // Sidebar content (rendered first)
    {% for section_name in sidebar_section_names %}
      {{ render_section(section_name) }}
    {% endfor %}
  ],
  [
    // Main content
    {% for section_name in main_section_names %}
      {{ render_section(section_name) }}
    {% endfor %}
  ]
)
```

**Template Rendering Logic** (`src/rendercv/renderer/templater/templater.py`):
- Modify to separate sections into sidebar/main groups
- Pass both groups to Preamble template
- Render sections in correct order within each column

### 3. Files to Create/Modify

#### New Files:
- `src/rendercv/schema/models/design/sidebar_theme.py` - Theme definition
- `src/rendercv/renderer/templater/templates/typst/sidebar/` - Custom templates

#### Files to Modify:
- `src/rendercv/schema/models/design/design.py` - Register new theme
- `src/rendercv/renderer/templater/templater.py` - Add sidebar rendering logic
- `src/rendercv/renderer/templater/templates/typst/Preamble.j2.typ` - Add column layout

## Implementation Steps

1. **Create sidebar_theme.py** (copy classic, add Sidebar class)
2. **Register theme** in design.py
3. **Modify templater.py** to separate sections by sidebar config
4. **Update Preamble.j2.typ** with conditional 2-column layout
5. **Test with your CV**
6. **Install locally**: `uv pip install -e .`

## Example YAML Configuration

```yaml
design:
  theme: sidebar
  sidebar:
    width: 30%
    position: left
    gutter: 0.5cm
    sections:
      - skills
      - publications
      - values
      - hobbies
      - references
```

## Next Steps

1. Start with Step 1: Create sidebar_theme.py
2. Test incrementally
3. Iterate on styling
