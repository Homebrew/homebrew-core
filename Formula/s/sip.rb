class Sip < Formula
  desc "Tool to create Python bindings for C and C++ libraries"
  # upstream page 404 report, https://github.com/Python-SIP/sip/issues/7
  homepage "https://python-sip.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/99/85/261c41cc709f65d5b87669f42e502d05cc544c24884121bc594ab0329d8e/sip-6.8.3.tar.gz"
  sha256 "888547b018bb24c36aded519e93d3e513d4c6aa0ba55b7cc1affbd45cf10762c"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c72ef903a6273a299314786f62bb0dd7514c671e815e03f1986637e50b389fa3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1215a87c1cd9ebf7a19c58591a4947d7e01669ea188cf38169ec6f84d2563616"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "161ac2919ec3990d7462fffbabc623301b02db130ddcdbf11f44b6ff84f8b976"
    sha256 cellar: :any_skip_relocation, sonoma:         "abedf2f58e97a6bd15b937cad168225e7f56b5998ed5898307d4021ba3a51638"
    sha256 cellar: :any_skip_relocation, ventura:        "0b83c01077f716d62be770898c1d718e81285f2969e3998d9675e70061110e83"
    sha256 cellar: :any_skip_relocation, monterey:       "6c34630d0ec9a45a2a5270079d2aa6ce1a930bb4e0dd20a0e5b812f45d098e9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12eb797765c96258bc8e1bff5bb62689d9ee3fed08419ca8d4312a3c86d811e6"
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
