class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/76/d9/5e1048d2f2fa6714e0d76382810b0fa81400c40e25b1f4f46c1a82e48364/sip-6.0.3.tar.gz"
  sha256 "929e3515428ea962003ccf6795244a5fe4fa6e2c94dc9ab8cb2c58fcd368c34c"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 1
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7d014c77da8de72d9e329e3c1128a8f0efa031eabe8c4b8cb921935e35d724de"
    sha256 cellar: :any_skip_relocation, big_sur:       "a837368bc4d0e64107acb61b064bc27c1635beadd2cc2ddd12c0802624a81fb2"
    sha256 cellar: :any_skip_relocation, catalina:      "dcad44f2a371e168ea960b42e91b745afb2f36a7199644830e37d128af4fecfc"
    sha256 cellar: :any_skip_relocation, mojave:        "8a9516100d8af37bae956d3e3c5495b66504f1098acefa7906aa75662b5ace89"
  end

  depends_on "python@3.9"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  # TODO: remove them after sip 6.1.0
  # These patch provide the option `--scripts-dir`
  patch do
    url "https://www.riverbankcomputing.com/hg/sip/raw-diff/ffd0551c32cc/sipbuild/builder.py"
    sha256 "2c969dfba2e4b0553d06999a3aa07a93ea4b7ca2cce62635d1418ecdc74a6df2"
  end

  patch do
    url "https://www.riverbankcomputing.com/hg/sip/raw-diff/ffd0551c32cc/sipbuild/project.py"
    sha256 "ea99834ab404583a1a49a05997950758fe95ba473129438117ffa5647028d99a"
  end

  def install
    python = Formula["python@3.9"]
    venv = virtualenv_create(libexec, python.bin/"python3")
    resources.each do |r|
      venv.pip_install r
    end

    system python.bin/"python3", *Language::Python.setup_install_args(prefix)

    site_packages = Language::Python.site_packages(python)
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-sip.pth").write pth_contents
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

    system "sip-install", "--target-dir", "."
  end
end
