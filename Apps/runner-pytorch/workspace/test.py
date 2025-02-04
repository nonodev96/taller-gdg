import torch
from tabulate import tabulate


def print_info_pytorch():
    info_cuda = [
        ["torch.__version__", torch.__version__],
        ["torch cuda is_available", torch.cuda.is_available()],
        ["torch cuda current_device", torch.cuda.current_device()],
        ["torch cuda device_count", torch.cuda.device_count()],
        ["torch cuda get_device_name", torch.cuda.get_device_name(0)],
        ["torch cuda is_initialized", torch.cuda.is_initialized()],
        ["torch cuda memory_allocated", torch.cuda.memory_allocated(0)],
        ["torch cuda memory_reserved", torch.cuda.memory_reserved(0)],
        ["torch cuda max_memory_allocated", torch.cuda.max_memory_allocated(0)],
        ["torch cuda max_memory_reserved", torch.cuda.max_memory_reserved(0)],
        ["torch backends cpu get_cpu_capability", torch.backends.cpu.get_cpu_capability()],
        ["torch backends cudnn  is_available", torch.backends.cudnn.is_available()],
        ["torch backends mkl    is_available", torch.backends.mkl.is_available()],
        ["torch backends mkldnn is_available", torch.backends.mkldnn.is_available()],
        ["torch backends mps    is_available", torch.backends.mps.is_available()],
        ["torch backends openmp is_available", torch.backends.openmp.is_available()],
    ]
    print(tabulate(info_cuda, headers=["Variable", "Value"]))

print_info_pytorch()