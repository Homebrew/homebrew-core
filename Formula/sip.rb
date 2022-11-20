class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/fd/9b/8e727256983e5b1d975f8dfce6f477b5ab6bada14a00b07fa3db51fcd6fe/sip-6.7.5.tar.gz"
  sha256 "9655d089e1d0c5fbf66bde11558a874980729132b5bd0c2ae355ac1a7b893ab4"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccf89f35a98dfddda7a8be95dad66aed47662a27d9fd501ae187910e46def4c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4925aeffbcb2d9eec8ecc8b4de62ee4d1cb5b9cc911518c26638a3b51d7a7a0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "632ab65d16c753a7656c3daa06a8ea4f45a76cb3438e8d73e0e1b4089f6c20fc"
    sha256 cellar: :any_skip_relocation, ventura:        "0a6090985cd5661aa0e3ebbac8ff1c4157355efa17c19f693b1e6dbffc74302f"
    sha256 cellar: :any_skip_relocation, monterey:       "f6f319543831812b9338ba7c05f9f0e7b6f64a24e5905c696d52a1beffdb20c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "07ba02b93639447a23fcc0f35569ab4a8cddb9ad9a5e0b14b29675baeb478a0c"
    sha256 cellar: :any_skip_relocation, catalina:       "e8417eab9c02b7b33849e7ad0140e1983e3a00d7751958e29e32ad1bf6768d30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e875a661e4394389c080e0b0fbbb6be6ec7385aae445644a740f4e3ba03aafac"
  end

  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    python3 = "python3.11"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    # We don't install into venv as sip-install writes the sys.executable in scripts
    system python3, *Language::Python.setup_install_args(prefix, python3)

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

    system "sip-install", "--target-dir", "."
  end
end
