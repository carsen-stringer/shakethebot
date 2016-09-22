%% where are my GPUs?
gpuDeviceCount % how many GPU devices I have
gpuDevice      % which GPU am I using and how much memory do I have
idgpu = 1;
gpuDevice(idgpu)  % resets the GPU (clears ALL GPU arrays)
                  % even if you still see them in the workspace they're
                  % gone!


%% can generate them on the CPU and then put on GPU
N = 5000;
tic;
x = randn(N,'single');
x = gpuArray(x);
x(1);
toc;
gpuDevice    % did we use some memory?


%% can generate arrays directly on the GPU
tic;
x = gpuArray.randn(N,'single');
x(1);
toc;


%% let's run some benchmarks to see where GPUs excel
GPUvsCPU;


%% there are a lot of built in functions for GPUs!
http://www.mathworks.com/help/distcomp/run-built-in-functions-on-a-gpu.html
