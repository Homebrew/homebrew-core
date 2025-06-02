class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/0f/37/6964b830433e654ec7485e45a00fc9a27cf868d622838f6b6d9c5ec0d532/scipy-1.15.3.tar.gz"
  sha256 "eae3cf522bc7df64b42cad3925c876e1b0b6c35c1337c93e12c0f366f55b0eaf"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "40cea0dc46f7aa2d88fc5a140f1fe386b55455de1cd09cefca45b8b45776a614"
    sha256 cellar: :any,                 arm64_sonoma:  "f7c9fe1a35de9df3a6d1a92511d2d4d8e5f7c1896c1110a7c54c79276bd2c55a"
    sha256 cellar: :any,                 arm64_ventura: "961e2fa1986097233fdc3103e7acd39816be4a22ca5cd4fd326abf47827dd7f5"
    sha256 cellar: :any,                 sonoma:        "61704bc83e517fe3032a787f08cab4beb81fe4e48ad5aa9aa774183ba885f519"
    sha256 cellar: :any,                 ventura:       "4e20878042bf0982ce80c571507b33c3c654092c5679d24564c954e6cf943741"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff04634fffe1e28ed408efbd1a9902c9eb74d279ce6e1202b87637763d439313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3897bebc7e283cee35014239d82102cb0ddc96fe987c3ecf98e9ccc08c5c6a9f"
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
