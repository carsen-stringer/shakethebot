% function GPUvsCPU()
% this is a very simple benchmark

% GTX 980Ti 
% Matrix multiplication...
% GPU 4966 Gflops. CPU 215 Gflops. 
% Matrix addition...
% GPU 391.566 GB/s. CPU 22.835 GB/s. 
% 
% GTX 970
% Matrix multiplication...
% GPU 3177 Gflops. CPU 229 Gflops. 
% Matrix addition...
% GPU 219.080 GB/s. CPU 23.516 GB/s.
% 
% GTX 960 
% Matrix multiplication...
% GPU 1210 Gflops. CPU 150 Gflops. 
% Matrix addition...
% GPU 149.562 GB/s. CPU 19.462 GB/s. 


fprintf('Matrix multiplication...\n')

% A = gpuArray(single(A));
% C = A + B;
% % all sorts of functions
% A = gather(A);

N = 2048;
niter = 10;
A = gpuArray.randn(N, 'single');
B = gpuArray.randn(N, 'single');
C = A * B;
C(1) + C(2);

tic
for i = 1:niter
    C = A * B;
end
C(1) + C(2);
t_gpu = toc;
nflops = niter * N * N * N * 2/2^30;

fprintf('GPU %2.0f Gflops. ', nflops/t_gpu)
%
A = randn(N, 'single');
B = randn(N, 'single');
C = A * B;
C(1) + C(2);

tic
for i = 1:niter
    C = A * B;
end
C(1) + C(2);
t_cpu = toc;

fprintf('CPU %2.0f Gflops. \n', nflops/t_cpu)

fprintf('Matrix addition...\n')
N = 2048;
niter = 500;
A = gpuArray.randn(N, 'single');
B = gpuArray.randn(N, 'single');
C = A * B;
C(1) + C(2);

tic
for i = 1:niter
    C = 2*C + A;
end
C(1) + C(2);
t_gpu = toc;
nfloats = 3*niter * N * N  * 4/2^30;

fprintf('GPU %2.3f GB/s. ', nfloats/t_gpu)

A = randn(N, 'single');
B = randn(N, 'single');
C = A * B;
C(1) + C(2);

tic
for i = 1:niter
    C = C + A;
end
C(1) + C(2);
t_cpu = toc;

fprintf('CPU %2.3f GB/s. \n', nfloats/t_cpu)
