class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/ce/8c/f66d1c45946e73a46f258b9628fe974ba8cc46c41b4750a59be192981695/sip-6.7.11.tar.gz"
  sha256 "f0dc3287a0b172e5664931c87847750d47e4fdcda4fe362b514af8edd655b469"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a4c6049eba350e7795a8e3ba19b4b9150575e8dcf40bde9a89261789b1d68f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47eb91421fbf5ed2c726d80be60bc4730c7082226c5b33746f5327846263b0e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98d9682254001ee8721ba4527c311d5cffc3e791005283e7795b68cfc2948fbb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f55acf4ce4d164cae3e3c86274b53b787d43617568073136e360b7eda6d33bee"
    sha256 cellar: :any_skip_relocation, sonoma:         "f37e138f32234efeedb4975551309a7769659a181e8ea42cf0efac6a775dea61"
    sha256 cellar: :any_skip_relocation, ventura:        "2cf97225325841cff1e07f69fb5cc94a09bf75fdaae617170445909e5f80a0da"
    sha256 cellar: :any_skip_relocation, monterey:       "c0f4489b6e8a1a3e24f5adc2ccadd2606dcab48c59edb58f51e1d1df43334103"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1501ec969fac71fa2158ea258d43ceee3ca3352c2df2136756b6bfcf0fe09ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b58d1f9da3e17886c6da54b3a67f9acc519953a7145cd1ebe84b10a85d9a0c44"
  end

  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  def install
    python3 = "python3.11"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    # We don't install into venv as sip-install writes the sys.executable in scripts
    system python3, "-m", "pip", "install", *std_pip_args, "."

    site_packages = Language::Python.site_packages(python3)
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

    system "#{bin}/sip-install", "--target-dir", "."
  end
end
