import csv
import numpy as np
import matplotlib.pyplot as plt

class Loader():
    def __init__(self, bin_width, datapath):
        self.bin_width = bin_width
        self.table = []

        # Load CSV x-y data
        data = []
        with open(datapath, 'r') as file:
            reader = csv.reader(file)
            for row in reader:
                x, y = map(float, row)
                data.append((x, y))

        # Determine x and y range
        self.x_min = min(data, key=lambda point: point[0])[0]
        self.x_max = max(data, key=lambda point: point[0])[0]
        self.y_min = min(data, key=lambda point: point[1])[1]
        self.y_max = max(data, key=lambda point: point[1])[1]
        x_range = self.x_max - self.x_min
        y_range = self.y_max - self.y_min
        print(self.x_min,self.x_max,self.y_min,self.y_max)

        # Calculate number of bins
        self.x_num_bins = int(x_range / self.bin_width) + 1
        self.y_num_bins = int(y_range / self.bin_width) + 1

        # Create bins
        bins = np.zeros((self.x_num_bins, self.y_num_bins))

        # Count data points in each bin
        for point in data:
            # print(point[0] - self.x_min)
            # print(self.x_num_bins)
            x_index = int((point[0] - self.x_min) // self.bin_width)
            y_index = int((point[1] - self.y_min) // self.bin_width)
            bins[x_index][y_index] += 1
            # print(bins[x_index][y_index])

        # Calculate probabilities
        total_points = len(data)
        # print(bins)
        probabilities = bins / total_points
        # print(probabilities)

        # Store probabilities in self.table
        self.table = probabilities.tolist()

    def __str__(self):
        return str(self.table)
    
    def display(self):
        plt.imshow(self.table, cmap='twilight', interpolation='nearest')
        plt.colorbar()
        plt.show()