#include <stdio.h>
#include <cuda_runtime.h>

__global__ void cuda_hello()
{
    printf("Hello World from GPU!\n");
}

void print_device_info(int device)
{
    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, device);

    printf("========================================\n");
    printf(" GPU %d: %s\n", device, prop.name);
    printf("========================================\n");
    printf("  Compute Capability: %d.%d\n", prop.major, prop.minor);
    printf("  Multi procesadores: %d\n", prop.multiProcessorCount);
    printf("  CUDA Cores (aprox.): %d\n", prop.multiProcessorCount * 128); // Estimación
    printf("  Frecuencia GPU: %.2f MHz\n", prop.clockRate / 1000.0);
    printf("  Memoria global: %.2f GB\n", prop.totalGlobalMem / (1024.0 * 1024.0 * 1024.0));
    printf("  Memoria compartida por bloque: %zu KB\n", prop.sharedMemPerBlock / 1024);
    printf("  Tamaño máximo de bloque: %d\n", prop.maxThreadsPerBlock);
    printf("  Número máximo de hilos por multi procesador: %d\n", prop.maxThreadsPerMultiProcessor);
    printf("  Tamaño máximo de grid: (%d, %d, %d)\n", prop.maxGridSize[0], prop.maxGridSize[1], prop.maxGridSize[2]);
    printf("  Tamaño de warp: %d hilos\n", prop.warpSize);
    printf("  Registros por bloque: %d\n", prop.regsPerBlock);
    printf("  Memoria constante: %zu KB\n", prop.totalConstMem / 1024);
    printf("  Ancho de banda (bus de memoria): %d bits\n", prop.memoryBusWidth);

    printf("  Tensor Cores disponibles: %d\n", prop.asyncEngineCount);       // Disponibilidad de Tensor Cores (si está presente en la GPU)
    printf("  Caché L1 global soportada: %s\n", prop.globalL1CacheSupported ? "Sí" : "No");
    printf("  Caché L1 local soportada: %s\n", prop.localL1CacheSupported ? "Sí" : "No");
    printf("  Tamaño de la caché L2: %.2f KB\n", prop.l2CacheSize / 1024.0); // Tamaño de la caché L2 (si está disponible)
    printf("  GPU parte de una tarjeta multi-GPU: %s\n", prop.isMultiGpuBoard ? "Sí" : "No");
    printf("  GPU multi-GPU ID: %d\n", prop.multiGpuBoardGroupID);
    printf("  Ratio de rendimiento de precisión simple a doble (obsoleto): %d\n", prop.singleToDoublePrecisionPerfRatio);
    printf("  Memoria compartida por bloque (opt-in): %zu KB\n", prop.sharedMemPerBlockOptin / 1024);
    printf("  Memoria compartida reservada por bloque: %zu bytes\n", prop.reservedSharedMemPerBlock);
    printf("  Máximo número de bloques por multi procesador: %d\n", prop.maxBlocksPerMultiProcessor);
    printf("  Se puede usar punteros de host para memoria registrada: %s\n", prop.canUseHostPointerForRegisteredMem ? "Sí" : "No");
    printf("  Acceso concurrente a memoria gestionada: %s\n", prop.concurrentManagedAccess ? "Sí" : "No");
    printf("  Acceso a memoria paginada a través de las tablas de página del host: %s\n", prop.pageableMemoryAccessUsesHostPageTables ? "Sí" : "No");
    printf("  Acceso directo a memoria gestionada desde el host: %s\n", prop.directManagedMemAccessFromHost ? "Sí" : "No");
    printf("  Tamaño máximo de ventana de política de acceso: %d\n", prop.accessPolicyMaxWindowSize);
    printf("  Soporte de operaciones atómicas nativas entre el host y la GPU: %s\n", prop.hostNativeAtomicSupported ? "Sí" : "No");
    printf("  Soporte para preempción de cómputo: %s\n", prop.computePreemptionSupported ? "Sí" : "No");
    printf("  Soporte para CUDA Computed Bindings: %s\n", prop.deviceOverlap ? "Sí" : "No");
    printf("  Soporte para lanzar kernels cooperativos: %s\n", prop.cooperativeLaunch ? "Sí" : "No");
    printf("  Soporte para lanzamiento cooperativo de múltiples dispositivos (obsoleto): %s\n", prop.cooperativeMultiDeviceLaunch ? "Sí" : "No");
    printf("  Soporte para registrar memoria del host: %s\n", prop.hostRegisterSupported ? "Sí" : "No");
    printf("  Soporte para arrays dispersos CUDA: %s\n", prop.sparseCudaArraySupported ? "Sí" : "No");
    printf("  Soporte para registrar memoria como solo lectura: %s\n", prop.hostRegisterReadOnlySupported ? "Sí" : "No");
    printf("  Soporte para interoperabilidad con semáforos de línea de tiempo: %s\n", prop.timelineSemaphoreInteropSupported ? "Sí" : "No");
    printf("  Soporte para pools de memoria: %s\n", prop.memoryPoolsSupported ? "Sí" : "No");
    printf("  Soporte para GPUDirect RDMA: %s\n", prop.gpuDirectRDMASupported ? "Sí" : "No");
    printf("  Soporte para arrays CUDA con mapeo diferido: %s\n", prop.deferredMappingCudaArraySupported ? "Sí" : "No");
    printf("  Soporte para eventos IPC: %s\n", prop.ipcEventSupported ? "Sí" : "No");
    printf("  Opciones de eliminación de RDMA de escritura de GPUDirect: %u\n", prop.gpuDirectRDMAFlushWritesOptions);
    printf("  Orden de escritura RDMA de GPUDirect: %d\n", prop.gpuDirectRDMAWritesOrdering);
    printf("  Tipos de manejadores soportados con IPC basado en pools de memoria: %u\n", prop.memoryPoolSupportedHandleTypes);
    printf("  Lanzamiento de clúster: %s\n", prop.clusterLaunch ? "Sí" : "No");
    printf("  Punteros unificados: %s\n", prop.unifiedFunctionPointers ? "Sí" : "No");
    
    printf("  PCI Bus ID: %d\n", prop.pciBusID);
    printf("  PCI Device ID: %d\n", prop.pciDeviceID);
    printf("  PCI Domain ID: %d\n", prop.pciDomainID);
    
    printf("\n");
}

int cuda_info()
{
    int device_count;
    cudaGetDeviceCount(&device_count);

    if (device_count == 0)
    {
        printf("No se encontraron GPUs compatibles con CUDA.\n");
        return 1;
    }    

    int driverVersion = 0;
    int runtimeVersion = 0;
    cudaDriverGetVersion(&driverVersion);
    cudaRuntimeGetVersion(&runtimeVersion);

    printf("  Versión del controlador CUDA: %d.%d\n", driverVersion / 1000, (driverVersion % 100) / 10);
    printf("  Versión del runtime CUDA: %d.%d\n", runtimeVersion / 1000, (runtimeVersion % 100) / 10);

    printf("Se encontraron %d GPU(s) compatibles con CUDA.\n\n", device_count);

    for (int i = 0; i < device_count; i++)
    {
        print_device_info(i);
    }

    return 0;
}

int main()
{
    cuda_hello<<<1, 1>>>();
    cuda_info();
    return 0;
}