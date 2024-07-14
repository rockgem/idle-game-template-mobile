extends Resource
class_name ShopData


export(bool) var shop_bought = false
export(Texture) var shop_icon
export(String) var shop_name: String = 'Shop Name'
export(int) var shop_buy = 1000
export(float, 1.4, 4.0) var shop_buy_price_mult = 1.4
export(float) var shop_produce_time = 10.0  #seconds
export(float) var shop_current_produce_time = 0.0  #should be saved and retrieved
export(int) var shop_level = 0
export(float) var shop_produce = 1
export(bool) var shop_manager_enabled = false
export(int) var shop_manager_price = 5000
export(bool) var upgraded: bool = false
export(int) var upgrade_cost: int = 2000000
export(float) var upgrade_multiplier: float = 1
