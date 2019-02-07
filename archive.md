---
layout: page
permalink: /blog/
title: Блог
crawlertitle: Все статьи
summary: Все записи блога
active: archive
bg: 'blog/blog.jpg'
bg_out_vk: 'blog/blog_537x240.jpg'
bg_post_fb: 'blog/blog_1200x630.jpg'
bg_post_instagram: 'blog/blog_1080x1080.jpg'
bg_post_ok: 'blog/blog_1680x1680.jpg'
bg_post_twitter: 'blog/blog_1024x512.jpg'
bg_post_vk: 'blog/blog_700x500.jpg'
---

{% for tag in site.tags %}
  {% assign t = tag | first %}
  {% assign posts = tag | last %}

  <h2 class="tag-key" id="{{ t | downcase }}">
    {% if t == 'latex' %}
      LaTeX
    {% else %}
      {{ t | capitalize }}
    {% endif %}
  </h2>
  
  <ul class="year">
    {% for post in posts %}
      {% if post.tags contains t %}
        <li>
          {% if post.lastmod %}
            <a href="{{ post.url }}">{{ post.title }}</a>
            <span class="date">{{ post.lastmod | date: "%d-%m-%Y"  }}</span>
          {% else %}
            <a href="{{ post.url }}">{{ post.title }}</a>
            <span class="date">{{ post.date | date: "%d-%m-%Y"  }}</span>
          {% endif %}
        </li>
      {% endif %}
    {% endfor %}
  </ul>
{% endfor %}
