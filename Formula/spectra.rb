class Spectra < Formula
  desc "Header-only C++ library for large scale eigenvalue problems"
  homepage "https://spectralib.org"
  url "https://github.com/yixuan/spectra/archive/v1.0.0.tar.gz"
  sha256 "45228b7d77b916b5384245eb13aa24bc994f3b0375013a8ba6b85adfd2dafd67"
  license "MPL-2.0"
  head "https://github.com/yixuan/spectra.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "94ec682e71349c61a98833532eff13ccd1242f0c1aed9100b3de5fb6cb76fa45"
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

    expected = <<~EOS
      5 Eigenvalues found:
      1000.01
      999.017
      997.962
      996.978
      996.017
    EOS

    assert_equal expected, shell_output(testpath/"test")
  end
end
