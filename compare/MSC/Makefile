my_benchmark: benchmark_uh_case.cc ../ir.h
	g++ benchmark_uh_case.cc -std=c++11 -o benchmark_uh

benchmark: benchmark.cc ../ir.h
	g++ benchmark.cc -std=c++11 -o benchmark

clean:
	rm ./benchmark

clear:
	rm ./2d* ./3d* ./*.sh ./*.c ./*.o ./*.out

run:
	./benchmark
