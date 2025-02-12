import tensorflow as tf
from tensorflow.python.client import device_lib
from tabulate import tabulate


def get_available_devices():
    local_device_protos = device_lib.list_local_devices()
    return [x.name for x in local_device_protos]


print(get_available_devices())


def print_info_tf2():

    list_physical_devices = tf.config.list_physical_devices("GPU")
    if list_physical_devices:
        memory_info = tf.config.experimental.get_memory_info("GPU:0")
        memory_usage = tf.config.experimental.get_memory_usage("GPU:0")
        device_details = tf.config.experimental.get_device_details(list_physical_devices[0])
                        

    info_tf = [
        ["tf.__version__", tf.__version__],
        ["tf test is_built_with_cuda", tf.test.is_built_with_cuda()],
        ["tf test is_gpu_available", tf.test.is_gpu_available()],
        ["tf test gpu_device_name", tf.test.gpu_device_name()],
        ["tf config list_physical_devices (GPU)", list_physical_devices],
        ["tf config experimental get_memory_info(0)", memory_info],
        ["tf config experimental get_memory_usage(0)", memory_usage],
        ["tf config experimental get_device_details(0)", device_details],
        ["----","----"],
        ["tf device_lib", device_lib.list_local_devices()]
    ]

    print(tabulate(info_tf, headers=["Variable", "Value"]))


print_info_tf2()
