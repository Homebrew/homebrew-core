class Thundersvm < Formula
  desc "Fast SVM Library on GPUs and CPUs"
  homepage "https://github.com/Xtra-Computing/thundersvm"
  url "https://github.com/Xtra-Computing/thundersvm/archive/0.3.3.tar.gz"
  sha256 "0328511caa762ebbf5f7174c2a3cf7a05393b93fff51a6819bcdd5b25e5c54ae"

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "gcc"

  def install
    inreplace "CMakeLists.txt", "${PROJECT_SOURCE_DIR}/eigen", "#{Formula["eigen"].opt_include}/eigen3"

    mkdir "build" do
      args = std_cmake_args

      args << "-DCMAKE_C_COMPILER=gcc-9"
      args << "-DCMAKE_CXX_COMPILER=g++-9"

      # keep same performance as when built manually
      args << "-DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG -O3"

      args << "-DUSE_CUDA=OFF"
      args << "-DUSE_EIGEN=ON"

      system "cmake", "..", *args
      system "make"

      bin.install "bin/thundersvm-predict"
      bin.install "bin/thundersvm-train"
      lib.install "lib/libthundersvm.dylib"
    end

    pkgshare.install "dataset"
  end

  test do
    system "#{bin}/thundersvm-train", "-c", "100", "-g", "0.5", "#{pkgshare}/dataset/test_dataset.txt"
  end
end
