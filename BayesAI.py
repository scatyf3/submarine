import numpy as np

class BayesAI():
    def __init__(self,data,q) -> None:
        self.data = data #List
        self.q = q #仪器准确度？
        self.prob_to_find = []
        self.p_final = 0

    def move(self):
        # find max
        max_value = max(max(row) for row in self.data.table)
        max_row_index = next((i for i, row in enumerate(self.data.table) if max_value in row), None)
        max_col_index = self.data.table[max_row_index].index(max_value)
        # updata max elem
        p = self.data.table[max_row_index][max_col_index]
        # 计算本次找到的概率
        mul_sum = 1
        for prob in self.prob_to_find:
            mul_sum = mul_sum*(1-prob)
        self.p_final = 1 - mul_sum
        # 更新本次找到的几率
        self.prob_to_find.append(p*self.q)
        new_p = p*(1-self.q)/((1-p)+p*(1-self.q))
        self.data.table[max_row_index][max_col_index] = new_p

        print("Bot updata index ",max_row_index,max_col_index,"👾🤖")
        print("previous p",p)
        print("new p",new_p)
        #updata other elem🤖
        print(self.data)
        result = []
        max_row_index, max_col_index = 0, 0  # 假设为之前更新的值

        for row_index, row in enumerate(self.data.table):
            new_row = []
            for col_index, value in enumerate(row):
                if row_index == max_row_index and col_index == max_col_index:
                    new_row.append(value)  # 不做改变
                else:
                    new_value = value * (1 / (1 - p * self.q))  # 进行变换操作
                    new_row.append(new_value)
            result.append(new_row)
        self.data.table = result
        print(self.data)
        



    