class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/b1/42/d47a0f4e1b1213ba7319b046a2e543b5d7f79964852cae262f35ca30a50c/sip-6.8.1.tar.gz"
  sha256 "3002df415e168ac3ffe393942dbc7131cb82ade50000e1526f46a88ade26f598"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f14d24030406bc957a956ab56ea6a1729d0164a78ca17cee84b386cdf8f5f84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "596e836c25f6a44c9abe30b92734baf0f3ebffdac0e933db0666cf8cba9b10d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbef16f6a5066b616cb44956fa664d81f0c6d2019d5d24935e5d39e5c1734df1"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b7f0601e829369b6c716807e3a661db410ac9c0ad6f1f19b2c94ae3e0141ca0"
    sha256 cellar: :any_skip_relocation, ventura:        "3db6ec3214ffee9299c6deac4e4351547c7f046e856535f4f45419f9a54506a2"
    sha256 cellar: :any_skip_relocation, monterey:       "f23948049fb077c867e06249832a70ca7cc1307a5fdd7db7c99fb62a0bd88564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92a2007dbea1afe34cfd7afb2d076e6ff27bc7ca69a2f4253f19406573485e00"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-packaging"
  depends_on "python-ply"
  depends_on "python-setuptools"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .sort_by(&:version)
  end

  def install
    clis = %w[sip-build sip-distinfo sip-install sip-module sip-sdist sip-wheel]

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."

      pyversion = Language::Python.major_minor_version(python_exe)
      clis.each do |cli|
        bin.install bin/cli => "#{cli}-#{pyversion}"
      end

      next if python != pythons.max_by(&:version)

      # The newest one is used as the default
      clis.each do |cli|
        bin.install_symlink "#{cli}-#{pyversion}" => cli
      end
    end
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      # Specify sip v6 as the build system for the package.
      [build-system]
      requires = ["sip >=6, <7"]
      build-backend = "sipbuild.api"

      # Specify the PEP 566 metadata for the project.
      [tool.sip.metadata]
      name = "fib"
    EOS

    (testpath/"fib.sip").write <<~EOS
      // Define the SIP wrapper to the (theoretical) fib library.

      %Module(name=fib, language="C")

      int fib_n(int n);
      %MethodCode
          if (a0 <= 0)
          {
              sipRes = 0;
          }
          else
          {
              int a = 0, b = 1, c, i;

              for (i = 2; i <= a0; i++)
              {
                  c = a + b;
                  a = b;
                  b = c;
              }

              sipRes = b;
          }
      %End
    EOS

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      pyversion = Language::Python.major_minor_version(python_exe)

      system "#{bin}/sip-install-#{pyversion}", "--target-dir", "."
    end
  end
end
