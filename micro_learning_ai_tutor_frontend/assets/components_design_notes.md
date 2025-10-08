# Components Design Notes

- LessonCard:
  - Title, badges (duration + tags), progress bar.
  - Card radius 12, border #E5E7EB, subtle shadow.

- QuizCard:
  - Title, question count, difficulty badge (Easy/Medium/Hard).
  - Badge uses tinted background and colored border.

- ProgressDashboard:
  - Icon + title + linear progress + streak text.

- AiFeedbackPanel:
  - Title + short guidance + primary action button.

- AdaptiveRecommendations:
  - Section title + 3 rows.
  - Each row: icon, title, tags, chevron.

- Accessibility:
  - Touch targets >= 44px height.
  - Contrast-safe colors for text and buttons.
