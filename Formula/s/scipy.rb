class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/4e/e5/0230da034a2e1b1feb32621d7cd57c59484091d6dccc9e6b855b0d309fc9/scipy-1.14.0.tar.gz"
  sha256 "b5923f48cb840380f9854339176ef21763118a7300a88203ccd0bdd26e58527b"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8d67847d431450f294b50115b771a84e1aeb14917b5c05e23724bedca528d548"
    sha256 cellar: :any,                 arm64_ventura:  "c397f3ea73abf01756d662f612eefc63e7ecbde23afb225ea24e98df07bcb669"
    sha256 cellar: :any,                 arm64_monterey: "f68095516dcb6a316dabab2f5296a9415a71204f5e9e1e9267cb1e53db138c91"
    sha256 cellar: :any,                 sonoma:         "188cc838894029b318b485b4276ba7e0537824b5f34889612d6585b6c84df9fd"
    sha256 cellar: :any,                 ventura:        "2b1b6945f4e073e63b7506dbbeca67731d073b13a10e8974c8b4f6fadc27783b"
    sha256 cellar: :any,                 monterey:       "e33c90c4d050595f3e710f3e2605aaeb0826d024f55b6ef57914f3f18679e627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bb68c0e41e2bb894a43025119c4938a8ebf805b5fa89b901fce309d444a2046"
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
