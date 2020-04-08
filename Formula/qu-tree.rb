class QuTree < Formula
  desc "C++ linear algebra package for tensor trees"
  homepage "https://github.com/roman-ellerbrock/QuTree"
  url "https://github.com/roman-ellerbrock/QuTree/archive/v0.1.0.tar.gz"
  sha256 "7914a1a738eaa5a5d13a62aacc2ec7e3f49b68b31e3b0cd6ba951392545cc619"

  depends_on "cmake" => :build
  depends_on "unittest-cpp" => :test
  depends_on "eigen"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.0)
      project(examples CXX)

      find_package(QuTree REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test QuTree::QuTree)
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include <Core/Tensor.h>
      #include <Core/Matrix.h>
      int main()
      {
        TensorShape tdim({2, 3, 4});
        Tensord A(tdim);

        for (size_t i = 0; i < A.shape().totalDimension(); i++) {
            A(i) = i;
        }

        Matrixd w = A.DotProduct(A);
        w.print();
      }
    EOS
    system "cmake", "."
    system "make"
    assert_equal %w[55 145 235 325 145 451 757 1063 235 757 1279 1801 325 1063 1801 2539],
      shell_output("./test").split
  end
end
