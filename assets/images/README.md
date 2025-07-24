# Prosody Labs - Strategic Visual Asset Management

## Professional Design Philosophy

This directory represents a **sophisticated visual storytelling strategy** that moves beyond literal representation to create emotional connections and compelling narratives around AI education and research.

## Strategic Directory Structure

```
assets/images/
├── heroes/           # Iconic, Brand-Defining Visuals
├── courses/          # Learning & Creativity Focused
├── projects/         # Advanced Technology Narratives
├── blog/             # Thought Leadership & Analysis
├── research/         # Scientific Discovery & Knowledge
└── general/          # Universal Themes & Aspirations
```

## Visual Narrative Strategy

### `/heroes/` - Brand Icons
- **ai-brain-networks.jpg** - The ultimate AI education visual: brain with neural networks
  - *Purpose*: Represents the intersection of human intelligence and AI
  - *Impact*: Immediately communicates our core mission

### `/courses/` - Learning Journey
- **creative-learning.jpg** - Paint brushes symbolizing creative education
- **knowledge-foundation.jpg** - Books representing deep academic knowledge  
- **art-of-teaching.jpg** - Artist at work showing skill development

*Strategy*: Emphasizes creativity, artistry, and human skill in AI education

### `/projects/` - Technology Excellence
- **ai-networks.jpg** - Robotic hand touching network connections
- **data-landscapes.jpg** - 3D data visualization landscapes
- **server-infrastructure.jpg** - Advanced computing infrastructure

*Strategy*: Sophisticated tech imagery that conveys intelligence and capability

### `/blog/` - Insight & Vision
- **future-vision.jpg** - Silhouette against cityscape (aspiration/vision)
- **research-insight.jpg** - Coffee and research materials (thoughtful analysis)
- **thoughtful-analysis.jpg** - Classic typewriter (content creation)

*Strategy*: Human-centered imagery that conveys depth, reflection, and insight

### `/research/` - Scientific Discovery
- **scientific-discovery.jpg** - Laboratory research environment
- **academic-knowledge.jpg** - Classic books and academic resources
- **data-visualization.jpg** - Advanced data modeling and visualization

*Strategy*: Conveys rigor, discovery, and academic excellence

### `/general/` - Universal Themes
- **aspiration.jpg** - Silhouette with city view (growth/vision)
- **creative-process.jpg** - Colorful gradient silhouette (innovation)
- **digital-transformation.jpg** - Network connections (transformation)

*Strategy*: Aspirational imagery that inspires and motivates

## Design Psychology

### Emotional Resonance
- **Human Elements**: People, hands, silhouettes create personal connection
- **Aspirational Imagery**: Sunsets, cityscapes, gradients inspire growth
- **Creative Tools**: Brushes, books, art supplies emphasize skill development
- **Advanced Technology**: Networks, data landscapes show sophistication

### Color Harmony
- **Warm Tones**: Sunset oranges, creative golds for aspiration
- **Cool Tech**: Blues, purples for advanced technology
- **Natural Elements**: Earth tones for human connection
- **Vibrant Accents**: Gradients and lighting for innovation

### Visual Hierarchy
1. **Heroes**: Most impactful, brand-defining imagery
2. **Courses**: Creative, human-centered learning visuals
3. **Projects**: Sophisticated technology demonstrations
4. **Research**: Academic and scientific credibility
5. **General**: Universal themes for broad appeal

## Strategic Implementation

### Storytelling Sequence
1. **Hero Brain Networks** → "We merge human and artificial intelligence"
2. **Creative Learning Tools** → "Education is an art form"
3. **Advanced Technology** → "We build sophisticated systems"
4. **Scientific Research** → "Our work is academically rigorous"
5. **Aspirational Vision** → "We're building the future"

### Brand Differentiation
- **Beyond Generic Tech**: Focus on human creativity and artistry
- **Academic Credibility**: Scientific and research-focused imagery
- **Emotional Connection**: People, aspirations, and human stories
- **Innovation Leadership**: Cutting-edge visual representations

## Impact Metrics

### Visual Engagement
- **Higher Emotional Response**: Human-centered imagery increases connection
- **Professional Credibility**: Scientific and research visuals build trust
- **Innovation Perception**: Advanced tech imagery positions us as leaders
- **Accessibility**: Clear, compelling visuals serve all audiences

### Brand Positioning
- **Educational Excellence**: Creative learning imagery
- **Technical Leadership**: Sophisticated technology visuals
- **Research Authority**: Academic and scientific credibility
- **Future Vision**: Aspirational and transformative themes

---

*This strategic approach transforms Prosody Labs from a typical tech company into a visionary leader in AI education, emphasizing creativity, human connection, and transformative potential.*

**Last Updated: June 2025**  
**Strategic Visual Direction: Professional Design & Communications**

# Image Management for Prosody Labs

This directory contains all images used throughout the Prosody Labs website, organized by content type and use case.

## 📁 Directory Structure

```
assets/images/
├── heroes/          # Brand and hero imagery
├── courses/         # Educational and learning imagery  
├── projects/        # Technology and development imagery
├── insights/        # Communication and content imagery
├── research/        # Scientific and academic imagery
├── general/         # Inspirational and collaborative imagery
└── publications/    # Academic publication imagery
```

## 🎯 Collection Images

### Adding Images to Collection Items

To add an image to any collection item (courses, projects, insights, research), simply add an `image` field to the front matter:

```yaml
---
title: "Your Item Title"
image: "/assets/images/site/your-image.jpg"
# ... other fields
---
```

### Image Naming Convention

Images should be named descriptively based on their visual content:
- ✅ `books-standing-row.jpg` (describes what's in the image)
- ✅ `scientist-blue-liquid-lab.jpg` (describes the scene)
- ❌ `course-hero.jpg` (describes intended use, not content)

### Fallback System

If no `image` field is provided, the system automatically displays attractive colored boxes with relevant icons:

- **Courses**: Blue gradient with graduation cap icon
- **Projects**: Green gradient with cogs icon  
- **Insights**: Purple gradient with lightbulb icon
- **Research**: Orange gradient with flask icon

This ensures visual consistency even when images aren't available yet.

## 🎨 Visual Strategy

Our image strategy emphasizes:

1. **Content Relevance**: Each image semantically matches its section's purpose
2. **Visual Consistency**: Professional, high-quality imagery throughout
3. **Emotional Resonance**: Images support narrative and brand story
4. **Technical Quality**: Optimized images with proper aspect ratios

## 📐 Technical Specifications

- **Recommended Size**: 800x600px minimum for detailed sections
- **Aspect Ratio**: 4:3 or 16:10 preferred
- **Format**: JPG for photos, PNG for graphics with transparency
- **File Size**: Aim for <500KB for web optimization
- **Quality**: High resolution but web-optimized

## 🔄 Updating Images

1. Add new images to the appropriate category folder
2. Use descriptive filenames based on visual content
3. Update collection item front matter with `image: "/assets/images/site/filename.jpg"`
4. Test both desktop and mobile layouts
5. Verify fallback behavior when image is not specified

## 🎯 Status Badge Colors

Collection items can display status badges with automatic color coding:

- **Active/Live**: Green gradient
- **Development**: Orange gradient  
- **Beta Testing**: Purple gradient
- **Enrolling**: Green gradient

Simply add a `status` field to the collection item front matter.

---

This system ensures that your content always looks professional, whether or not specific images have been added to each item. 