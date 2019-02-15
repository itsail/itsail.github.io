---
layout: post
title: "[CLI] Работа с изображениями в линуксе"
date: 2017-01-09 00:44:35 +0300
tags: [Линукс, Разработка]
slug: cli-working-with-images-in-linux
author: idoka
sources_url: http://idoka.ru/
summary: Спецсимволы HTML, или символы-мнемоники, представляют собой конструкцию SGML, ссылающуюся на определенные символы из символьного набора документа
categories: blog
bg: '2019/cli_working_with_images_in_linux_index.jpg'
bg_out_vk: '2019/cli_working_with_images_in_linux_537x240.jpg'
bg_post_fb: '2019/cli_working_with_images_in_linux_1200x630.jpg'
bg_post_instagram: '2019/cli_working_with_images_in_linux_1080x1080.jpg'
bg_post_ok: '2019/cli_working_with_images_in_linux_1680x1680.jpg'
bg_post_twitter: '2019/cli_working_with_images_in_linux_1024x512.jpg'
bg_post_vk: '2019/cli_working_with_images_in_linux_700x500.jpg'
---

В наше время всё чаще сайты сталкиваются с необходимостью введения отзывчивого дизайна и отзывчивых картинок – а в связи с этим есть необходимость эффективного изменения размера всех картинок. Система должна работать так, чтобы каждому пользователю по запросу отправлялась картинка нужного размера – маленькие для пользователей с небольшими экранами, большие – для больших экранов.

Веб таким образом работает отлично, но для доставки картинок разных размеров разным пользователям необходимо все эти картинки сначала создать.

Множество инструментов занимается изменением размера, но слишком часто они выдают большие файлы, аннулирующие выигрыш в быстродействии, который должен приходить вместе с отзывчивыми картинками. Давайте рассмотрим, как при помощи ImageMagick, инструмента командной строки, быстренько изменять размеры картинок, сохраняя превосходное качество и получая файлы небольших объёмов.

## ImageMagick: однострочники

### Узнать размеры изображения

По вертикали:

```bash
height=`identify -ping -format "%h" IMG_4450.JPG`
```

По горизонтали:

```bash
width=`identify -ping -format "%w" IMG_4450.JPG`
```

### Склейка нескольких картинок в один файл

Склеить все изображения в директории в матрицу 2х2 по 4 изображения:

```bash
montage *.jpg -tile 2x2 -geometry +10+10 out.jpg
```

Склеить 2 изображения в столбец 1х2 (по вертикали):

```bash
montage BMW_420d.jpg BMW_425d.jpg -tile 1x2 -geometry +10+10 BMW_xDrive.jpg
```

Склеить 2 изображения в строку 2х1 (по горизонтали):

```bash
montage BMW_520d.jpg BMW_525d.jpg -tile 2x1 -geometry +10+10 BMW_M5.jpg
```

Подписать каждое изображение в коллаже именем файла:

```bash
montage *.jpg -label %f -frame 10 -tile 2x2 -geometry +10+10 out.jpg
```

здесь:

* `-geometry +10+10` — белые поля вокруг каждого изображения, заданные в пикселях
* `-frame 10` — 3D-рамка, пиксели
* `-label %f` — подпись

### Рассово-верный резайс картинок
    
```bash
convert guy_fawkes.png -adaptive-resize 500x guy_fawkes_500x.png
```

Устаревший способ с ручным способом повышения чёткости картинки:

```bash
convert $1 -filter Lanczos -sharpen $sharp -quality $quality -resize $newsize -verbose $2
```

### Растяжение гистограммы изображения (повышение цветовой чёткости)

Автоматический режим через normalize (также см. -auto-level и -auto-gamma):

```bash
convert $1 -normalize -sharpen $sharp -quality $quality -resize $newsize $2
```

Ручное задание через linear-stretch на сколько % (в пикселях) снизу и сверху подвинуть гистограмму, можно задавать два числа в формате 5%x5%, также может использоваться с модификатором -channel:

```bash
convert $1 -linear-stretch 7% -quality $quality -resize $newsize $2
```

или через повышение контраста:

```bash
convert $1 -contrast-stretch 5%x5% -quality $quality -resize $newsize $2
```

*Тонкие подробности: https://www.imagemagick.org/Usage/color_mods/#stretching*

### Подмена цвета

Если у нас есть, например, QR-код после онлайн-генератора, окрашенный в стандартный черный цвет, а мы хотим выкрасить его в один из корпоративных цветов (например, для вставки в CV или на визитку), сделать это можно следующей командой:

```bash
convert create-qr-code.png -fuzz 0% -fill '#39а' -opaque '#000' qr-code-kaspersky.png
```

здесь:

* `-opaque '#000'` — какой цвет искать
* `-fill '#39а'` — на какой подменять
* `-fuzz 0%` — точность задания цвета (отклонение 0%, т.е. искать и подменять только точно совпадающий с #000 цветом)

Если у нас картинка в полутонах, то задаём выше допустимое отклонение:

```bash
convert guy_fawkes.png -fuzz 80% -fill '#39а' -opaque '#000' guy_fawkes_kaspersky.png
```

### Посмотреть список доступных шрифтов

```bash
convert -list font | grep Font | grep -i имя_шрифта
```

Именно выводимое название следует использовать для опции `-font` команды `convert`.

## Оптимизация изображений

### JPEG

Установка `jpegtran`:

```bash
$ yum search jpegtran
libjpeg-turbo-utils.x86_64 : Utilities for manipulating JPEG images
$ sudo yum install -y libjpeg-turbo-utils
```

Использование:

```bash
jpegtran -copy none -optimize -outfile $file_out $file_in
```

Второй доступный инструмент — `jpegoptim`:

```bash
sudo yum install -y jpegoptim
```

Использование:

```bash
jpegoptim --quiet --strip-all --stdout $file_in > $file_out
```

С данными настройками оба тула дают идентичный размер выходных файлов.

Для размещения файлов в сети желательно использовать опцию progressive, например, для `jpegoptim`:

```bash
jpegoptim --quiet --strip-all --all-progressive --stdout $file_in > $file_out
```

### PNG

Что доступно в репах:

```bash
advancecomp.x86_64 : Recompression utilities for .PNG, .MNG and .ZIP files
optipng.x86_64     : PNG optimizer and converter
pngcrush.x86_64    : Optimizer for PNG (Portable Network Graphics) files
pngnq.x86_64       : Pngnq is a tool for quantizing PNG images in RGBA format
pngquant.x86_64    : PNG quantization tool for reducing image file size
```

Устанавливаем:

```bash
sudo yum install -y optipng advancecomp pngcrush pngnq pngquant
```

Жмём:

```bash
optipng -o7 -out automotive_logofeature-optipng.png automotive_logofeature.png
advpng -z -4 -i 50 automotive_logofeature-advpng.png
advdef -z -4 -i 50 automotive_logofeature-advdef.png
pngcrush -brute -reduce automotive_logofeature.png automotive_logofeature-pngcrush.png
pngnq -s 1 -v automotive_logofeature-pngnq.png
pngquant --speed 1 --force automotive_logofeature-pngquant.png
```

Результаты:

```bash
58019 байт  -  automotive_logofeature-оригинал.png
55449 байт  -  automotive_logofeature-optipng.png
53224 байт  -  automotive_logofeature-advdef.png
52086 байт  -  automotive_logofeature-pngcrush.png
38080 байт  -  automotive_logofeature-advpng.png
30961 байт  -  automotive_logofeature-pngquant.png
15796 байт  -  automotive_logofeature-pngnq.png
```

Тройка лидеров:

1. **pngnq** (ужал ~4 раза)
2. **pngquant** (ужал ~2 раза)
3. **advpng** (ужал ~1.5 раза)

> Однако всплыло одно но: `advpng` умеет оптимизировать изображения, которые по какой-то причине не ужимают ни `pngnq`, ни `pngquant`: Google PageSpeed перестал жаловаться только после дополнительного прохода по файлам утилитой `advpng`.

### SVG

#### batik-svgpp

Batik SVG pretty printer — The SVG Pretty Printer lets developers «pretty-up» their SVG files and get their tabulations and other cosmetic parameters in order. It can also be used to modify the DOCTYPE declaration on SVG files

#### svgcleaner

Пакетная очистка SVG-файлов от ненужной информации, утилита удаляет атрибуты, не участвующие в формировании конечного изображения, а задействованные атрибуты приводит к более компактному виду. Размер файла может быть уменьшен на 60%.

> Поскольку удаляется информация и в выключеных/скрытых слоях, то утилиту стоит рассматривать как инструмент подготовки `publishing svg-files`.

Зависимости:

* libxcb-xinerama0
* p7zip

```bash
sudo yum install -y p7zip libXinerama libXinerama-devel
```

Запуск:

```bash
./svgcleaner input.svg output.svg
```
