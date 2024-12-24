import torch
import random
import numpy as np


def set_seed(seed, device_id='cuda:0'):
    # Set seed for Python's built-in random library
    random.seed(seed)
    # Set seed for numpy
    np.random.seed(seed)
    # Set seed for PyTorch CPU
    torch.manual_seed(seed)

    if torch.cuda.is_available():
        # Set device-specific seed for the specified GPU
        torch.cuda.set_device(device_id)
        torch.cuda.manual_seed(seed)

        # Ensure deterministic behavior on the specified GPU (may impact performance)
        torch.backends.cudnn.deterministic = True
        torch.backends.cudnn.benchmark = False

