class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/62/11/4d44a1f274e002784e4dbdb81e0ea96d2de2d1045b2132d5af62cc31fd28/scipy-1.14.1.tar.gz"
  sha256 "5a275584e726026a5699459aa72f828a610821006228e841b94275c4a7c08417"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6727575f0867f1039c2b473e01404f3e1e5c0dd40a5f589251be77cf3aa0d771"
    sha256 cellar: :any,                 arm64_sonoma:   "2148d339325ed35253ab5932b2f1173dc27ccc2dd0fd5824fac8803afb109090"
    sha256 cellar: :any,                 arm64_ventura:  "694ff1f342f3c8a2bf9e5395fc0880702dd916af27223fc978d3da3886f1a524"
    sha256 cellar: :any,                 arm64_monterey: "2b7727f7d9ac60e357a1bfa0a11d1dfa6923ee6c2ed5afbedb8c6bd46630ec46"
    sha256 cellar: :any,                 sonoma:         "ca1af7099de12b5621f76f51d903c19bcffa59a8915ae2f903a60a87e17d0b6c"
    sha256 cellar: :any,                 ventura:        "e812b863c129425d46d5e85a7b066f0313ce3380a17d1b3a720e33ab05708dff"
    sha256 cellar: :any,                 monterey:       "c4092245f269cec545011209abbde8c4d628ec10c831d18ad321157e3bebd52b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d350cfed231253b7ea035004e390fb90c7609e773b264e5c959997a02470c808"
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
    rm(Dir["#{HOMEBREW_PREFIX}/lib/python*.*/site-packages/scipy/**/*.pyc"])
  end

  test do
    (testpath/"test.py").write <<~EOS
      from scipy import special
      print(special.exp10(3))
    EOS
    assert_equal "1000.0", shell_output("#{python3} test.py").chomp
  end
end
