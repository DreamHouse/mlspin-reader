# 种草和维护草坪
lawn_maintain_tag = Tag.where(name: "种草和维护草坪").first
Article.create!(title: "草坪维护基础知识", 
    desc: "唉，这版上是不是新地主比较多啊？给大家补补基础知识吧。除草剂叫“Weed B Gone” 绝大多数都是只杀阔叶杂草 (Broad leaf weed)",
    source_link: "http://www.mitbbs.com/bbsann2/life.faq/Living/maintain/D1303780124220/M.1313338047_2.N0/%E8%8D%89%E5%9D%AA%E7%BB%B4%E6%8A%A4%E5%9F%BA%E7%A1%80%E7%9F%A5%E8%AF%86",
    publish_date: Date.new(2011, 8, 14),
    author: "张老大",
    content: "唉，这版上是不是新地主比较多啊？给大家补补基础知识吧。除草剂叫“Weed B Gone” 绝大多数都是只杀阔叶杂草 (Broad leaf weed)，
  也有其它牌子的，标签上有注明可以杀哪些草，以及用量。Roundup 顾名思义是一锅端，千万别用来除草地上杂草，不然后果你明白。",
    tags: [lawn_maintain_tag])

Article.create!(title: "手把手教你如何打理草坪", 
    desc: "买了房子后用过专业的园艺公司，后来也自己动手打理。如果你家草坪不是很大大，要求不是很高（在小区中等偏上），完全可以DIY。这里给各位新买了房子打算自己打
理草坪的人说说我的入门级经验。以下适用于东部地区cool season grasses (KBG, feacus etc.) 并以新泽西为例。往南往北的可以酌情调整时间。",
    source_link: "http://www.mitbbs.com/article/Living/33442765_0.html",
    publish_date: Date.new(2015, 3, 16),
    author: "tuna(mitbbs)",
    content: "买了房子后用过专业的园艺公司，后来也自己动手打理。如果你家草坪不是很大大，要求不是很高（在小区中等偏上），完全可以DIY。这里给各位新买了房子打算自己打
理草坪的人说说我的入门级经验。以下适用于东部地区cool season grasses (KBG, feacus etc.) 并以新泽西为例。往南往北的可以酌情调整时间。",
    tags: [lawn_maintain_tag])
