class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/30/85/cdbf2c3c460fe5aae812917866392068a88d02f07de0fe31ce738734c477/scipy-1.12.0.tar.gz"
  sha256 "4bf5abab8a36d20193c698b0f1fc282c1d083c94723902c447e5d2f1780936a3"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2e20c814e64a4bb5b51d1c82942885b66a3efc4287c9002e3a38c03eab79eaf4"
    sha256 cellar: :any,                 arm64_ventura:  "6c1b068f3e682d274d8146fb857a8279b1464c1879cc90b6aaa6051f0abbe8ee"
    sha256 cellar: :any,                 arm64_monterey: "668c2cb1e0e318200345791d0f697d4082868ef2af54ce3ad6d256cfda71c36c"
    sha256 cellar: :any,                 sonoma:         "b97fffd754623f5021c8446c741062b873308423a0280556e2a8fa5aee5aa31a"
    sha256 cellar: :any,                 ventura:        "8da1d21d767cf36ea51b497272beb6bdcdf7bf413f1f688c1a7aa2775405df25"
    sha256 cellar: :any,                 monterey:       "f735fd9772529888c4945460973b2a42c2535e1d28f65fdd720bde27f65a7180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44149ad76d523bb1fcb3c8c437671c81575d08fa177da1aa351d6d1e68739c60"
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
