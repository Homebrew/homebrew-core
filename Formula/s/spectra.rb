class Spectra < Formula
  desc "Header-only C++ library for large scale eigenvalue problems"
  homepage "https://spectralib.org"
  url "https://github.com/yixuan/spectra/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "919e3fbc8c539a321fd5a0766966922b7637cc52eb50a969241a997c733789f3"
  license "MPL-2.0"
  head "https://github.com/yixuan/spectra.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "15610bfef5010247b1b4199a7e471f32e2f09439eebcea7ca8ccc674798cda89"
  end

  depends_on "cmake" => :build
  depends_on "eigen"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/DavidsonSymEigs_example.cpp" => "test.cpp"
  end

  test do
    system ENV.cxx, pkgshare/"test.cpp", "-std=c++11",
           "-I#{Formula["eigen"].opt_include/"eigen3"}", "-I#{include}", "-o", "test"

    macos_expected = <<~EOS
      5 Eigenvalues found:
      1000.01
      999.017
      997.962
      996.978
      996.017
    EOS

    linux_expected = <<~EOS
      5 Eigenvalues found:
      999.969
      998.965
      997.995
      996.999
      995.962
    EOS

    if OS.mac?
      assert_equal macos_expected, shell_output(testpath/"test")
    else
      assert_equal linux_expected, shell_output(testpath/"test")
    end
  end
end
