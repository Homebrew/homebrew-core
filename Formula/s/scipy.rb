class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/ae/00/48c2f661e2816ccf2ecd77982f6605b2950afe60f60a52b4cbbc2504aa8f/scipy-1.13.1.tar.gz"
  sha256 "095a87a0312b08dfd6a6155cbbd310a8c51800fc931b8c0b84003014b874ed3c"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f0232ccf4999337f5c363af7a8701ac0a732149fb8a84931c0d69b8e64aabf78"
    sha256 cellar: :any,                 arm64_ventura:  "cdd83b0d9a0e1efc32fe49ba1e25e2d31818b8755cde3747a777485f4364a095"
    sha256 cellar: :any,                 arm64_monterey: "c1dcf9f03e83fac6d8eaa65368f324463bb97afebb7bddaa92655ccef7539972"
    sha256 cellar: :any,                 sonoma:         "4189f08bbe40706f518596baf1c0bfd6c14fb33c2a946a8859e2c6aa2caeb682"
    sha256 cellar: :any,                 ventura:        "f4279d62ac201ff8fb9e829a4b9af4a36f30df6b1e000da2ef178d2b2ceb7cef"
    sha256 cellar: :any,                 monterey:       "2a45f8adc2a75d28673146e760efebebddde2af17c468188a2aeabdab87537b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ee0e9125f6a4885048edb90341ebd4539c757eb0aa43e9fff0264d31f545092"
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
