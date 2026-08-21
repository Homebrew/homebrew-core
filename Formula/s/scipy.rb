class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/a7/25/c2700dfaf6442b4effaa91af24ebce5dc9d31bb4a69706313aae70d72cd0/scipy-1.18.0.tar.gz"
  sha256 "67b2ad2ad54c72ca6d04975a9b2df8c3638c34ddd5b28738e94fc2b57929d378"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b92df4485e202d58f5a5107b2446280864f8f3992e6e2785286ad893fab2dbda"
    sha256 cellar: :any, arm64_sequoia: "f8fc40293a3f5171c0a627613646e0c54c6a39075be1e953e314ba18725a9759"
    sha256 cellar: :any, arm64_sonoma:  "d82f0690bce17a28ea91ae8cf14664beeec8338690d2e044784b08c0b3b22545"
    sha256 cellar: :any, sonoma:        "62c88a03647feb8681cf7378b230de130f01e2c129e1fc96af192bec60171b39"
    sha256 cellar: :any, arm64_linux:   "d4469b728058a622f747d6660568ef0cc3ae9495dbae1659831bcf741af936d4"
    sha256 cellar: :any, x86_64_linux:  "a1c65ebe31d401c1410091c099cea4393d542fca2e12e68b8fba0934f856a41f"
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
