<script setup lang="ts">
import { computed, ref } from 'vue'

interface QuizQuestion {
  id: number
  topic: string
  question: string
  options: string[]
  correctIndex: number
  explanation: string
}

const questions: QuizQuestion[] = [
  {
    id: 1,
    topic: 'Chèo',
    question: 'Nhạc cụ nào giữ vai trò "linh hồn" dẫn dắt nhịp phách và đối đáp trực tiếp với diễn viên trong dàn nhạc Chèo?',
    options: [
      'Đàn đáy',
      'Trống đế',
      'Kèn bóp',
      'Guitar phím lõm',
    ],
    correctIndex: 1,
    explanation: 'Trống đế là nhạc cụ cốt lõi của dàn nhạc Chèo, dùng để bắt nhịp, nâng đỡ làn điệu và tạo điểm nhấn biểu cảm cùng vai diễn.',
  },
  {
    id: 2,
    topic: 'Tuồng (Hát Bội)',
    question: 'Trong nghệ thuật hóa trang mặt nạ Tuồng, gương mặt vẽ màu ĐỎ thường biểu trưng cho kiểu nhân vật nào?',
    options: [
      'Gian nịnh, xảo quyệt',
      'Hung dữ, phản trắc',
      'Trung nghĩa, dũng cảm',
      'Hóm hỉnh, châm biếm',
    ],
    correctIndex: 2,
    explanation: 'Hóa trang Tuồng mang tính ước lệ cao: Đỏ tượng trưng cho trung nghĩa, Trắng là gian nịnh, Đen là cương trực, Xanh/Xám là hung dữ hoặc mưu mô.',
  },
  {
    id: 3,
    topic: 'Cải lương',
    question: 'Bài Vọng cổ (nhịp 32) — trụ cột âm nhạc của Cải lương — phát triển từ tác phẩm gốc nào?',
    options: [
      'Lới lơ',
      'Hát khách',
      'Dạ cổ hoài lang',
      'Hát nói',
    ],
    correctIndex: 2,
    explanation: 'Bài Vọng cổ khởi nguồn từ bản "Dạ cổ hoài lang" (nhịp 2) của nhạc sĩ Cao Văn Lầu sáng tác năm 1919, dần phát triển lên nhịp 4, 8, 16 và 32.',
  },
  {
    id: 4,
    topic: 'Ca trù',
    question: 'Biên chế bộ ba kinh điển trong một chầu hát Ca trù bao gồm những thành phần nào?',
    options: [
      'Đào nương (hát + phách), Kép (đàn đáy), Quan viên (trống chầu)',
      'Đào thương (hát), Hề chèo (diễn), Nhạc công (trống đế)',
      'Nghệ sĩ hát, Kèn bóp, Trống chiến',
      'Ca sĩ, Guitar phím lõm, Đàn tranh',
    ],
    correctIndex: 0,
    explanation: 'Một chầu Ca trù chuẩn mực gồm Đào nương hát kết hợp gõ phách, Kép đệm đàn đáy độc đáo và Quan viên cầm trống chầu thưởng thức, thẩm định.',
  },
]

const currentIndex = ref(0)
const selectedAnswers = ref<(number | null)[]>(questions.map(() => null))

const currentQuestion = computed(() => questions[currentIndex.value])
const selectedForCurrent = computed(() => selectedAnswers.value[currentIndex.value])
const isAnswered = computed(() => selectedForCurrent.value !== null)
const isCorrect = computed(
  () => selectedForCurrent.value === currentQuestion.value.correctIndex,
)

const answeredCount = computed(
  () => selectedAnswers.value.filter((a) => a !== null).length,
)

const score = computed(() =>
  selectedAnswers.value.reduce((total, ans, idx) => {
    if (ans === questions[idx].correctIndex) return total + 1
    return total
  }, 0),
)

function selectOption(optionIdx: number) {
  if (selectedAnswers.value[currentIndex.value] !== null) return
  selectedAnswers.value[currentIndex.value] = optionIdx
}

function goToQuestion(idx: number) {
  currentIndex.value = idx
}

function nextQuestion() {
  if (currentIndex.value < questions.length - 1) {
    currentIndex.value += 1
  }
}

function resetQuiz() {
  selectedAnswers.value = questions.map(() => null)
  currentIndex.value = 0
}

function optionClass(idx: number) {
  const chosen = selectedForCurrent.value
  if (chosen === null) return 'option-idle'
  if (idx === currentQuestion.value.correctIndex) return 'option-correct'
  if (idx === chosen) return 'option-wrong'
  return 'option-dim'
}
</script>

<template>
  <div class="quiz-shell glass-card">
    <!-- Top Bar: Question tabs & score -->
    <div class="quiz-top">
      <div class="quiz-tabs" role="tablist" aria-label="Danh sách câu hỏi">
        <button
          v-for="(q, idx) in questions"
          :key="q.id"
          type="button"
          class="quiz-tab"
          :class="{
            active: idx === currentIndex,
            doneCorrect: selectedAnswers[idx] === q.correctIndex,
            doneWrong: selectedAnswers[idx] !== null && selectedAnswers[idx] !== q.correctIndex,
          }"
          @click="goToQuestion(idx)"
        >
          Câu {{ idx + 1 }} · {{ q.topic }}
        </button>
      </div>

      <div class="quiz-score">
        Điểm: <strong>{{ score }}/{{ questions.length }}</strong>
      </div>
    </div>

    <!-- Question prompt -->
    <div class="quiz-question">
      <span class="question-num">Câu {{ currentIndex + 1 }}</span>
      <p class="question-text">{{ currentQuestion.question }}</p>
    </div>

    <!-- Options grid -->
    <div class="options-grid">
      <button
        v-for="(opt, idx) in currentQuestion.options"
        :key="idx"
        type="button"
        class="option-btn"
        :class="optionClass(idx)"
        :disabled="isAnswered"
        @click="selectOption(idx)"
      >
        <span class="option-letter">{{ String.fromCharCode(65 + idx) }}</span>
        <span class="option-label">{{ opt }}</span>
      </button>
    </div>

    <!-- Feedback & Navigation -->
    <div class="quiz-footer">
      <div v-if="isAnswered" class="feedback-box" :class="isCorrect ? 'is-correct' : 'is-wrong'">
        <span class="feedback-badge">
          {{ isCorrect ? 'Chính xác!' : 'Chưa đúng' }}
        </span>
        <span class="feedback-text">{{ currentQuestion.explanation }}</span>
      </div>
      <div v-else class="feedback-placeholder">
        Chọn một đáp án trực tiếp trên slide để kiểm tra kết quả.
      </div>

      <div class="quiz-actions">
        <button
          v-if="currentIndex < questions.length - 1"
          type="button"
          class="action-btn primary"
          @click="nextQuestion"
        >
          Câu tiếp →
        </button>
        <button
          v-if="answeredCount > 0"
          type="button"
          class="action-btn ghost"
          @click="resetQuiz"
        >
          Làm lại
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.quiz-shell {
  display: flex;
  flex-direction: column;
  gap: 0.9rem;
  padding: 1.15rem 1.35rem;
}

.quiz-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 0.75rem;
  flex-wrap: wrap;
}

.quiz-tabs {
  display: flex;
  gap: 0.45rem;
  flex-wrap: wrap;
}

.quiz-tab {
  font-size: 0.74rem;
  font-weight: 500;
  color: #B8B5AD;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.12);
  border-radius: 999px;
  padding: 0.28rem 0.72rem;
  cursor: pointer;
  transition: all 0.2s ease;
}

.quiz-tab:hover {
  border-color: rgba(217, 119, 6, 0.5);
  color: #F5F0E6;
}

.quiz-tab.active {
  background: rgba(217, 119, 6, 0.22);
  border-color: #F59E0B;
  color: #F5F0E6;
  font-weight: 600;
}

.quiz-tab.doneCorrect {
  border-color: rgba(16, 185, 129, 0.6);
  color: #A7F3D0;
}

.quiz-tab.doneWrong {
  border-color: rgba(220, 38, 38, 0.65);
  color: #FECACA;
}

.quiz-score {
  font-size: 0.8rem;
  color: #B8B5AD;
  padding: 0.25rem 0.7rem;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.06);
  border: 1px solid rgba(255, 255, 255, 0.12);
}

.quiz-score strong {
  color: #F59E0B;
}

.quiz-question {
  display: flex;
  align-items: baseline;
  gap: 0.7rem;
}

.question-num {
  font-size: 0.72rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: #FDE68A;
  background: rgba(217, 119, 6, 0.2);
  border: 1px solid rgba(217, 119, 6, 0.4);
  padding: 0.2rem 0.55rem;
  border-radius: 8px;
  flex-shrink: 0;
}

.question-text {
  margin: 0;
  font-size: 0.98rem;
  font-weight: 600;
  color: #F5F0E6;
  line-height: 1.45;
}

.options-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 0.65rem;
}

.option-btn {
  display: flex;
  align-items: center;
  gap: 0.7rem;
  text-align: left;
  padding: 0.72rem 0.9rem;
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.14);
  background: rgba(255, 255, 255, 0.045);
  color: #F5F0E6;
  font-size: 0.84rem;
  line-height: 1.38;
  cursor: pointer;
  transition: all 0.2s ease;
}

.option-btn.option-idle:hover {
  background: rgba(217, 119, 6, 0.14);
  border-color: rgba(245, 158, 11, 0.55);
  transform: translateY(-1px);
}

.option-btn.option-correct {
  background: rgba(16, 185, 129, 0.18);
  border-color: rgba(52, 211, 153, 0.75);
  color: #ECFDF5;
}

.option-btn.option-wrong {
  background: rgba(220, 38, 38, 0.2);
  border-color: rgba(248, 113, 113, 0.75);
  color: #FEF2F2;
}

.option-btn.option-dim {
  opacity: 0.45;
}

.option-btn:disabled {
  cursor: default;
}

.option-letter {
  width: 24px;
  height: 24px;
  border-radius: 7px;
  background: rgba(255, 255, 255, 0.09);
  border: 1px solid rgba(255, 255, 255, 0.16);
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 0.74rem;
  font-weight: 700;
  color: #F5F0E6;
  flex-shrink: 0;
}

.option-label {
  flex: 1;
}

.quiz-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 0.85rem;
  min-height: 54px;
}

.feedback-box {
  flex: 1;
  display: flex;
  align-items: baseline;
  gap: 0.6rem;
  padding: 0.6rem 0.85rem;
  border-radius: 12px;
  font-size: 0.79rem;
  line-height: 1.42;
}

.feedback-box.is-correct {
  background: rgba(16, 185, 129, 0.14);
  border: 1px solid rgba(52, 211, 153, 0.45);
  color: #D1FAE5;
}

.feedback-box.is-wrong {
  background: rgba(220, 38, 38, 0.14);
  border: 1px solid rgba(248, 113, 113, 0.45);
  color: #FEE2E2;
}

.feedback-badge {
  font-weight: 700;
  white-space: nowrap;
}

.feedback-placeholder {
  flex: 1;
  font-size: 0.78rem;
  color: #8A8780;
  font-style: italic;
}

.quiz-actions {
  display: flex;
  gap: 0.45rem;
  flex-shrink: 0;
}

.action-btn {
  font-size: 0.76rem;
  font-weight: 600;
  padding: 0.45rem 0.85rem;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.action-btn.primary {
  background: linear-gradient(135deg, #D97706, #DC2626);
  color: #F5F0E6;
  border: none;
}

.action-btn.primary:hover {
  filter: brightness(1.1);
}

.action-btn.ghost {
  background: rgba(255, 255, 255, 0.06);
  color: #F5F0E6;
  border: 1px solid rgba(255, 255, 255, 0.16);
}

.action-btn.ghost:hover {
  border-color: rgba(255, 255, 255, 0.35);
}
</style>
