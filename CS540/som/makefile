all: main.cu
	nvcc -lGLU -lGL -lglut  -o som node.cu som.cu main.cu 
clean:
	$(RM) octree
