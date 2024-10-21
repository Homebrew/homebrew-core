class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/62/11/4d44a1f274e002784e4dbdb81e0ea96d2de2d1045b2132d5af62cc31fd28/scipy-1.14.1.tar.gz"
  sha256 "5a275584e726026a5699459aa72f828a610821006228e841b94275c4a7c08417"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "25343b0b788c75c936bbbc32ff84330f05b31e495bb577a7399bd8f321d5cb60"
    sha256 cellar: :any,                 arm64_sonoma:  "1e01d457a52a556d8e2205ea5165fa047535410cd9aab7613687a8e6e37fa74d"
    sha256 cellar: :any,                 arm64_ventura: "7d9598ba10fbf054aa315858a1c6ea1487bdfb7dc72caf3876906c414e5a92be"
    sha256 cellar: :any,                 sonoma:        "1af864a096e92b76016cb55ccacbdee0e633847e7f91ea3c8903acec49eebea0"
    sha256 cellar: :any,                 ventura:       "aeb20853b99a9ecb395477f0025b4748f94018d02e9160c2250005cd44b9fa52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8541dd700f2bd6fc5ee9e289ac286eed998b76823decdb18032f9fb17827ab0"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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

  fails_with gcc: "5"

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
    (testpath/"test.py").write <<~EOS
      from scipy import special
      print(special.exp10(3))
    EOS
    pythons.each do |python3|
      assert_equal "1000.0", shell_output("#{python3} test.py").chomp
    end
  end
end
