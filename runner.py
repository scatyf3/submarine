from Loader import Loader
from BayesAI import BayesAI

import pygame

# 初始化Pygame
pygame.init()

# 定义窗口尺寸
width, height = 800, 600

# 创建窗口
screen = pygame.display.set_mode((width, height))
pygame.display.set_caption("Results Visualization")

# 加载数据
data = Loader(500, "data/result_iter-pi:4-3600s.csv")

# 创建BayesAI对象
ai = BayesAI(data, 0.9)

# 定义颜色
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
RED = (255, 0, 0)
GREEN = (0, 255, 0)
DARK_BLUE = (0, 0, 128)
LIGHT_BLUE = (176, 224, 230)

# 渲染函数
def render():
    # 清空屏幕
    screen.fill(WHITE)

    # 获取数据
    table = ai.data.table

    # 计算单元格大小
    x_num_bins = ai.data.x_num_bins
    y_num_bins = ai.data.y_num_bins
    # 计算单元格大小
    cell_size = min(width // x_num_bins, height // y_num_bins)

    # print(x_num_bins,y_num_bins)

    # 遍历数据并绘制矩形
    for row in range(x_num_bins):
        for col in range(y_num_bins):
            cell_value = "{:.1f}%".format(table[row][col] * 100)  # 保留小数点后三位
            rect = pygame.Rect(col * cell_size, row * cell_size, cell_size, cell_size)
            # print(row,col)

            if row == x_num_bins - 1 and col == y_num_bins - 1:
                pygame.draw.rect(screen, GREEN, rect)
            elif table[row][col] >= 0.01:  # 概率高的块使用深蓝色
                pygame.draw.rect(screen, DARK_BLUE, rect)
            else:  # 概率低的块使用浅蓝色
                pygame.draw.rect(screen, LIGHT_BLUE, rect)

            pygame.draw.rect(screen, BLACK, rect, 1)
            text = pygame.font.SysFont(None, 24).render(str(cell_value), True, BLACK)
            text_rect = text.get_rect(center=rect.center)
            screen.blit(text, text_rect)

    # 绘制底部窗口
    pygame.draw.rect(screen, WHITE, (0, height - 100, width, 100))
    pygame.draw.rect(screen, RED, (20, height - 80, 120, 40))
    button_text = pygame.font.SysFont(None, 24).render("AI MOVEEE", True, WHITE)
    button_text_rect = button_text.get_rect(center=(80, height - 60))
    screen.blit(button_text, button_text_rect)

    # 显示ai.p_final的数值
    total_prob_text = pygame.font.SysFont(None, 24).render(
        "Find in this iteration Prob: {:.3f}".format(ai.p_final), True, BLACK)
    total_prob_rect = total_prob_text.get_rect(center=(width // 2, height - 60))
    screen.blit(total_prob_text, total_prob_rect)

    # 刷新屏幕
    pygame.display.flip()


# 游戏循环
running = True
while running:
    # 处理事件
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.MOUSEBUTTONDOWN:
            if event.button == 1:  # 左键点击
                mouse_pos = pygame.mouse.get_pos()
                if 20 <= mouse_pos[0] <= 140 and height - 80 <= mouse_pos[1] <= height - 40:  # ai move🤖按钮点击
                    ai.move()

    # 渲染结果
    render()
# 退出Pygame
pygame.quit()