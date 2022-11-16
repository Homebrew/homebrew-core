class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/08/f6/06ad8d62331b302b68fbd730eedec8346213db71857128cb3b8309fee2ad/sip-6.7.4.tar.gz"
  sha256 "9dbf8a0e7c8d76d1642e2fdd3f53e6a522f7c30980e527763c45760c2505cfbf"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 2
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17165afcbac295d1ba62f11b48996e5dcb76bb128bc96a494710f29374dcc5f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0294e06cd295c110e8d287415d3e17e6e27e6687c4d6548245f84a5e837a9f1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c90888377ac77f8e823507701ea7052a9f1fa8a028f2f952f301bf1791645094"
    sha256 cellar: :any_skip_relocation, ventura:        "e6cc029546c33d4d88176bb8fc6c44ad9c823a1e656c7523c3bb04d7d63d97fd"
    sha256 cellar: :any_skip_relocation, monterey:       "7f35a33f673037a9f39e1bce746a4cfa1e2aaf984b7af2c6b9e47b3bec6c0050"
    sha256 cellar: :any_skip_relocation, big_sur:        "11291c0669c733e5960cee03955ed85434fe6153df29eb3ba553f6a9048bf2f3"
    sha256 cellar: :any_skip_relocation, catalina:       "ce4fd10d484eecceaad05de32bd44c9634a27e5861939eb0db3a52e4888bb0dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ba89601a80140abe3c793e848eb2a1e0c66ee61b7dcc7b25877aca6acbabb88"
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
