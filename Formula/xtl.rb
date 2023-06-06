class Xtl < Formula
  desc "X template library"
  homepage "https://github.com/xtensor-stack/xtl"
  url "https://github.com/xtensor-stack/xtl/archive/refs/tags/0.7.5.tar.gz"
  sha256 "3286fef5fee5d58f82f7b91375cd449c819848584bae9367893501114d923cbe"
  license "BSD-3-Clause"
  head "https://github.com/xtensor-stack/xtl.git", branch: "master"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <xtl/xsystem.hpp>
      #include <iostream>

      int main() {
        std::cout << xtl::executable_path();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-o", "test"
    assert_equal "#{testpath}/test", shell_output("#{testpath}/test").strip
  end
end
