class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/fb/a3/328965862f41ba67d27ddd26205962007ec87d99eec6d364a29bf00ac093/scipy-1.13.0.tar.gz"
  sha256 "58569af537ea29d3f78e5abd18398459f195546bb3be23d16677fb26616cc11e"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1c5fe71be79054618e7a879de18dfd19fd03d2dc0b9d775fbf970046cd14b9a8"
    sha256 cellar: :any,                 arm64_ventura:  "3df91dbc81c3dafe569ddd89daf87aaa0a7944a5f29f747b9df4cc2ac830cbb8"
    sha256 cellar: :any,                 arm64_monterey: "e5e9a34d96505b866b3ef1f94f82ba2712473b582fdd6cd8614fd6b9fa629a6a"
    sha256 cellar: :any,                 sonoma:         "5b258b4ff10784dfe38254926af91819cc4ec104d3f958b4a92bb4e2c2339376"
    sha256 cellar: :any,                 ventura:        "7faa15e34598f920813b1f4709c1fc84f7601375c2741aa93b5a7d203807c22e"
    sha256 cellar: :any,                 monterey:       "e3e7176018871c3ae0a98a27ccb1d845311d4566159af2f2327b9c6e2d39793b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c0cfa35bee18f7989372edb3ff82926f59e9dd6c2b35f99c9c821da989aea2d"
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
