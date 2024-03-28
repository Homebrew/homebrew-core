class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/30/85/cdbf2c3c460fe5aae812917866392068a88d02f07de0fe31ce738734c477/scipy-1.12.0.tar.gz"
  sha256 "4bf5abab8a36d20193c698b0f1fc282c1d083c94723902c447e5d2f1780936a3"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "14309cef056fb3a80ee4008a4cee601ba400245d74c9bae56122a1c489d01804"
    sha256 cellar: :any,                 arm64_ventura:  "ee9573ade0845e6a45020febc9546af6aed2b0806c7adcbc0a7e6b2508e19da3"
    sha256 cellar: :any,                 arm64_monterey: "87e8bf8a997ed4e1645153ed962b0bb3085453029e4e01affb868bdd0ad9dbc2"
    sha256 cellar: :any,                 sonoma:         "1d61ae6e455049b29bb0c32c6be938ae882a15f26b6ab6a0758752b1f314dffb"
    sha256 cellar: :any,                 ventura:        "3eb8407e1c1e57b52a74b96f8b82ab92a4b30a52b7d713eef45f586586bb1a39"
    sha256 cellar: :any,                 monterey:       "88e8b4c895c25639b0ca0a7ee5a45cdb41a1e1ae2c1eb2fdfcbfebadca2c1504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3fee4a603c611e8ad336bc3fe9f6d8c354670b371cbe4cc29c2f4b1ae586c96"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.12"
  depends_on "xsimd"

  on_linux do
    depends_on "patchelf" => :build
  end

  cxxstdlib_check :skip

  fails_with gcc: "5"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https://github.com/Homebrew/homebrew-python/issues/185#issuecomment-67534979
  def post_install
    rm_f Dir["#{HOMEBREW_PREFIX}/lib/python*.*/site-packages/scipy/**/*.pyc"]
  end

  test do
    (testpath/"test.py").write <<~EOS
      from scipy import special
      print(special.exp10(3))
    EOS
    assert_equal "1000.0", shell_output("#{python3} test.py").chomp
  end
end
