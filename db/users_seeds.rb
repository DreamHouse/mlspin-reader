u = User.create!(email: "maojiayin@gmail.com", nickname: "max", confirmed_at: Date.new(2015, 5, 15), 
password: "123456")
u.confirm!