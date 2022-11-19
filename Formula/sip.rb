class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/fd/9b/8e727256983e5b1d975f8dfce6f477b5ab6bada14a00b07fa3db51fcd6fe/sip-6.7.5.tar.gz"
  sha256 "9655d089e1d0c5fbf66bde11558a874980729132b5bd0c2ae355ac1a7b893ab4"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91881d046dc8de18957d2e1ac5e5e0519b84cdba9ba4d9858a760060b089e0cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cc0e8d0ad17c4e0e68fe6d8284166004eacbdd765ede21a478f6c440fef977f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2155db2c598a1c987480342e7e879116fddfeee1a943e1f72628ffc7efc7e9c"
    sha256 cellar: :any_skip_relocation, ventura:        "53ff76309b368f456ddd63861fa0590bf87f91890ca4c236ba5224cf27ff7aa9"
    sha256 cellar: :any_skip_relocation, monterey:       "9203a6a76b703cb589ac64fb0c929b388aaf403c10947db0c194735039392d2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "de68a372d9a4a25e820c7911a4c65e27a70fc6257550de929c6595ce61405767"
    sha256 cellar: :any_skip_relocation, catalina:       "118e462852cbf49de0cb283c0c874271318b693368e0cc5ab2f039416e3663d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "590fa3ccb87e96352ce1108dfd17c0467ad81eab0cefd8f4b8c4422fb45234ce"
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
