Economy = class("Economy")

function Economy:initialize()
    self.prices = {
        ["Equipment"] = 200,
        ["Medical Supplies"] = 350,
        ["Ore"] = 125,
        ["Metal"] = 160,
        ["Water"] = 10,
    }

    self.commodities = {
        "Equipment",
        "Medical Supplies",
        "Ore",
        "Metal",
        "Water",
    }

    self.priceHistory = {}

    for i, commodity in pairs(self.commodities) do
        self.priceHistory[commodity] = {}
    end
end

function Economy:update()
    if self.prices ~= nil then
        for comm, price in pairs(self.prices) do
            table.insert(self.priceHistory[comm], price)
            if #self.priceHistory[comm] > 50 then
                table.remove(self.priceHistory[comm], 1)
            end
            self.prices[comm] = self.prices[comm] + math.ceil(math.random(-price*0.02, price*0.02))
        end
    end
end

function Economy:getCommodityAverage(commodity)
    local sum = 0

    for i, v in pairs(self.priceHistory[commodity]) do
        sum = sum + v
    end

    return math.ceil(sum/#self.priceHistory[commodity] - 0.5)
end