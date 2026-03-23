class Spectra < Formula
  desc "Header-only C++ library for large scale eigenvalue problems"
  homepage "https://spectralib.org"
  url "https://github.com/yixuan/spectra/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "fdfccacba1c77d9b4ffefae7258c760c99e3c8a2823ca87ea5b11a50d297a73b"
  license "MPL-2.0"
  head "https://github.com/yixuan/spectra.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "edd1c8fc5c4b6ea0ba64a9b48a0b86f986b0b24c4f6b624b45908b84ea3963f1"
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
    system ENV.cxx, pkgshare/"test.cpp", "-std=c++14",
           "-I#{Formula["eigen"].opt_include/"eigen3"}", "-I#{include}", "-o", "test"

    macos_expected = <<~EOS
      5 Eigenvalues found:
      999.971
       999.04
      997.993
      997.009
      996.023
    EOS

    linux_expected = <<~EOS
      5 Eigenvalues found:
      999.996
      998.952
       997.96
      996.972
      995.967
    EOS

    if OS.mac?
      assert_equal macos_expected, shell_output(testpath/"test")
    else
      assert_equal linux_expected, shell_output(testpath/"test")
    end
  end
end
