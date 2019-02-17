library(tuneR)
library(tidyverse)
getwd()


df.song <- readMidi('~/powerbi-blog/src/pages/scatterplot-midi-music/baby shark dance.mid')

df.tracks <- df.song %>%
  filter(event == 'Sequence/Track Name') %>%
  transmute(track, track_name = parameterMetaSystem)

df.notes <- getMidiNotes(df.song) %>%
  inner_join(df.tracks, by='track') 

df.notes %>%
  arrange(time) %>%
  head(50)

df.notes %>%
  filter(time < 300000) %>%
  ggplot(aes(time, note + track/max(track), xend=time + length, yend = note + track/max(track))) +
  geom_segment(size=1) +
  theme_void()



df.notes <- df.notes %>%
  filter(track_name != 'perc' | note != 98)
df.notes

df.notes %>%
  mutate(angle = 2 * pi * time / max(time + 1),
         radius = 25 + 75 * (note - min(note)) / (max(note) - min(note)),
         size = 5 * sqrt(length / max(length))) %>%
  ggplot(aes(radius * sin(angle), radius * cos(angle), size=size)) +
  geom_point(color="#356DF0", alpha=0.7) +
  theme_void() +
  scale_size_identity() +
  coord_equal()


df.notes %>%
  mutate(angle = 2 * pi * time / max(time + 1),
         radius = 25 + 75 * (note - min(note)) / (max(note) - min(note)),
         size = 5 * sqrt(length / max(length)))  -> baby_shark_df


p = baby_shark_df %>% ggplot(aes(radius * sin(angle), radius * cos(angle), size=size)) +
  geom_point(color="#356DF0", alpha=0.7) +
  theme_void() +
  scale_size_identity() +
  coord_equal()

p + transition_time(velocity) +
  labs(title = "Rhythm of baby shark: {frame_time}")


p + transition_time(velocity) +
  labs(title = "velocity: {frame_time}") +
  shadow_wake(wake_length = 0.1, alpha = FALSE)

library(glue)

df.notes %>%
  mutate(angle = -0.5 * pi + 2 * pi * time / max(time + 1),
         radius = 25 + 75 * (note - min(note)) / (max(note) - min(note)),
         size = round(4 * sqrt(length / max(length)), 1),
         color = colorRampPalette(c('#B31010', '#FDCC8A'))(max(note) - min(note))[note - min(note) + 1],
         x = round(radius * cos(angle), 1),
         y = round(radius * sin(angle), 1)) %>%
  with(paste0(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="-105 -105 210 210">',
    '<g>',
    paste0(glue('<circle cx="{x}" cy="{y}" r="{size}" fill="{color}" style="mix-blend-mode: multiply;" />'), collapse='\n'),
    '</g>',
    '</svg>')) %>%
  cat(file='out.svg')
