class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/7a/97/5a3609c4f8d58b039179648e62dd220f89864f56f7357f5d4f45c29eb2cc/scipy-1.17.1.tar.gz"
  sha256 "95d8e012d8cb8816c226aef832200b1d45109ed4464303e997c5b13122b297c0"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "78f1f5aed3d3b4f72f9df7ca3a12f9fbbe38b037eb3ed1f5267dd743c6ca8e7a"
    sha256 cellar: :any,                 arm64_sequoia: "2f74aa1069b4f9705fef6f6542d5f9912e99b642a554dc5e00c9dd3fda71f875"
    sha256 cellar: :any,                 arm64_sonoma:  "fba1a0ab3414bd57d0077ddf4e98ec75c983e745d3686dd4f9d6de08766d3e99"
    sha256 cellar: :any,                 sonoma:        "c8783212ebe892ba6f7b7ffae47c3cee9e75d73e51b27ce5b2c729c07251c954"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fff82c03b8ddb88896760fc68f86badcf38520a93046082af1d6937dcb21ca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e270d3de3e13788049162a7fd4b7d215fc3ddf08b4ae96d76cdec9d11e0ceea6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "xsimd"

  on_linux do
    depends_on "patchelf" => :build
  end

  pypi_packages exclude_packages: "numpy"

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
