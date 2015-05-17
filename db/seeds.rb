# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# load tax rates from tax_seed.rb

garden_tag = Tag.create!(name: "草坪、院子和花卉", level: 1, weight: 1, vocabulary: "维护房产")
outer_tag = Tag.create!(name: "屋顶、外墙、地基", 
  desc: "屋顶、外墙、地基相关的维护项目",
  level: 1, weight: 2, vocabulary: "维护房产")
inner_tag = Tag.create!(name: "室内维护", level: 1, weight: 3, vocabulary: "维护房产")
furniture_tag = Tag.create!(name: "家具家电", level: 1, weight: 4, vocabulary: "维护房产")
plumb_heat_tag = Tag.create!(name: "排水和取暖", level: 1, weight: 5, vocabulary: "维护房产")
other_tag = Tag.create!(name: "其他", level: 1, weight: 6, vocabulary: "维护房产")

garden_tag.add_child("种草和维护草坪")
garden_tag.add_child("砍树、剪枝和种树")
garden_tag.add_child("除虫除蚁")
garden_tag.add_child("栅栏")
garden_tag.add_child("游泳池、桑拿浴房和按摩池")

outer_tag.add_child("浇筑和维护地基")
outer_tag.add_child("地基和地下室防水")
outer_tag.add_child("车库和通道")
outer_tag.add_child("屋顶")
outer_tag.add_child("屋檐")
outer_tag.add_child("外墙维护")

inner_tag.add_child("门窗安装与更换")
inner_tag.add_child("地板与地毯")
inner_tag.add_child("厨房装修") # add more child items, countertop, cabinet, etc
inner_tag.add_child("卫生间")
inner_tag.add_child("内饰设计与房间布置")
inner_tag.add_child("墙")

furniture_tag.add_child("电力系统")
furniture_tag.add_child("家具选择与布置")
furniture_tag.add_child("网络、电话和有线电视")
furniture_tag.add_child("家庭影院")

plumb_heat_tag.add_child("锅炉和暖气")
plumb_heat_tag.add_child("中央空调系统")
plumb_heat_tag.add_child("电取暖设备")
plumb_heat_tag.add_child("疏通管道与更换龙头")
plumb_heat_tag.add_child("排水系统")

other_tag.add_child("保洁服务")
other_tag.add_child("节能改进")
other_tag.add_child("过冬准备")
other_tag.add_child("老年人服务")

require_relative 'article_seeds'

