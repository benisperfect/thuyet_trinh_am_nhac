<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  artForm: string
  region: string
  suggestedClip: string
  youtubeId?: string
  audioSrc?: string
  accent?: 'red' | 'gold'
}>()

const embedUrl = computed(() => {
  if (!props.youtubeId || !props.youtubeId.trim()) return ''
  return `https://www.youtube-nocookie.com/embed/${props.youtubeId.trim()}?rel=0`
})
</script>

<template>
  <div
    class="media-card glass-card"
    :class="accent === 'red' ? 'glass-card-red' : 'glass-card-gold'"
  >
    <div class="media-header">
      <div>
        <span class="media-title">{{ artForm }}</span>
        <span class="media-region">{{ region }}</span>
      </div>
      <span class="media-tag" :class="accent === 'red' ? 'red' : 'gold'">
        {{ embedUrl ? 'YouTube' : audioSrc ? 'Audio' : 'Placeholder' }}
      </span>
    </div>

    <div class="media-stage">
      <iframe
        v-if="embedUrl"
        :src="embedUrl"
        :title="`${artForm} - ${suggestedClip}`"
        class="media-iframe"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
        allowfullscreen
      />

      <div v-else-if="audioSrc" class="audio-wrap">
        <div class="clip-label">{{ suggestedClip }}</div>
        <audio controls :src="audioSrc" class="w-full mt-2" />
      </div>

      <div v-else class="media-placeholder">
        <div class="play-badge" :class="accent === 'red' ? 'red' : 'gold'">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
            <path d="M8 5v14l11-7z" />
          </svg>
        </div>
        <div class="placeholder-info">
          <div class="clip-label">{{ suggestedClip }}</div>
          <div class="clip-hint">
            Điền <code>youtubeId="..."</code> hoặc <code>audioSrc="..."</code> tại Slide 12
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.media-card {
  display: flex;
  flex-direction: column;
  gap: 0.65rem;
  padding: 0.9rem 1.05rem;
  height: 100%;
}

.media-header {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 0.5rem;
}

.media-title {
  font-family: 'Playfair Display', Georgia, serif;
  font-size: 1.05rem;
  font-weight: 700;
  color: #F5F0E6;
  margin-right: 0.45rem;
}

.media-region {
  font-size: 0.74rem;
  color: #9CA3AF;
}

.media-tag {
  font-size: 0.66rem;
  font-weight: 600;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  padding: 0.18rem 0.55rem;
  border-radius: 999px;
  border: 1px solid rgba(255, 255, 255, 0.14);
}

.media-tag.gold {
  color: #FDE68A;
  background: rgba(217, 119, 6, 0.16);
  border-color: rgba(217, 119, 6, 0.35);
}

.media-tag.red {
  color: #FECACA;
  background: rgba(220, 38, 38, 0.16);
  border-color: rgba(220, 38, 38, 0.35);
}

.media-stage {
  flex: 1;
  min-height: 112px;
  border-radius: 12px;
  overflow: hidden;
  background: rgba(11, 13, 18, 0.65);
  border: 1px dashed rgba(255, 255, 255, 0.16);
  display: flex;
  align-items: center;
  justify-content: center;
}

.media-iframe {
  width: 100%;
  height: 100%;
  min-height: 118px;
  border: none;
}

.audio-wrap {
  width: 100%;
  padding: 0.75rem 0.9rem;
}

.media-placeholder {
  display: flex;
  align-items: center;
  gap: 0.85rem;
  padding: 0.85rem 1rem;
  width: 100%;
}

.play-badge {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #F5F0E6;
}

.play-badge.gold {
  background: linear-gradient(135deg, rgba(217, 119, 6, 0.85), rgba(180, 83, 9, 0.65));
  box-shadow: 0 0 20px rgba(217, 119, 6, 0.35);
}

.play-badge.red {
  background: linear-gradient(135deg, rgba(220, 38, 38, 0.85), rgba(153, 27, 27, 0.65));
  box-shadow: 0 0 20px rgba(220, 38, 38, 0.35);
}

.placeholder-info {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  min-width: 0;
}

.clip-label {
  font-size: 0.82rem;
  font-weight: 600;
  color: #F5F0E6;
  line-height: 1.35;
}

.clip-hint {
  font-size: 0.7rem;
  color: #9A968E;
  line-height: 1.35;
}

.clip-hint code {
  font-size: 0.68rem;
  color: #FDE68A;
  background: rgba(255, 255, 255, 0.08);
  padding: 0.08rem 0.32rem;
  border-radius: 4px;
}
</style>
