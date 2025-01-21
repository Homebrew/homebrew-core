class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/76/c6/8eb0654ba0c7d0bb1bf67bf8fbace101a8e4f250f7722371105e8b6f68fc/scipy-1.15.1.tar.gz"
  sha256 "033a75ddad1463970c96a88063a1df87ccfddd526437136b6ee81ff0312ebdf6"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6472d44d3dfa4a422c6cdfab4b8a1cc9ee16b0c9e06b03f0c43c65ef8b6b479a"
    sha256 cellar: :any,                 arm64_sonoma:  "bc753cc567ec613d2e608bdc3f281d317924a942653ca97c6706854ac86bb75f"
    sha256 cellar: :any,                 arm64_ventura: "1439cbcfcdbd2703c0dc49255e2687ab98b816d783a3d000da41d1fd0a74b7e1"
    sha256 cellar: :any,                 sonoma:        "f1704b5265584a54bc1f7ecd6f01f0d111a574a6dae91a6afade3dab17181690"
    sha256 cellar: :any,                 ventura:       "0399839970756650f097d49c8f690b1c6ef4c6b8e82249b34732970f4aaca0a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33c52f32ca50f844b879507689f4be97a0f6a82b17e95059adc17ccf434e473f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "xsimd"

  on_linux do
    depends_on "patchelf" => :build
  end

  cxxstdlib_check :skip

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python3|
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  def post_install
    HOMEBREW_PREFIX.glob("lib/python*.*/site-packages/scipy/**/*.pyc").map(&:unlink)
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from scipy import special
      print(special.exp10(3))
    PYTHON
    pythons.each do |python3|
      assert_equal "1000.0", shell_output("#{python3} test.py").chomp
    end
  end
end
