class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/90/6d/00a06681a7659135018d219f62239709804573cbe615dfa2ba3e8933e097/sip-6.7.3.tar.gz"
  sha256 "564a7a8c5c1a42f1b69e9258af2b43ea31fbbab206d2e182e75c173caf7d83f8"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "028cb1285cd59fd7e7a98fc2a1d57fedca5c6193b2ad47c68e8576f0497db401"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d348f66122909d310d985c851af9626b16396d5b3d0c59d9cf56ee32a6341163"
    sha256 cellar: :any_skip_relocation, monterey:       "173995c8368473448fbb7fb8d3c7c82032a45e3c064763552d307a3ef25e6b7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a11bb86131abb34eb0ce1b5152c2a9b9d61aac0a75f8c35346ae3d120db07bc"
    sha256 cellar: :any_skip_relocation, catalina:       "5452a43221219cc6d2d85779ab80a6c31d6a4730e7b5037212e2b8d69d918ae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83f8c7c342e73667edbd1592da7abd5c7c9337382637c09ee578db95b2c50dcb"
  end

  depends_on "python@3.10"

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
    python3 = "python3.10"
    venv = virtualenv_create(libexec, python3)
    resources.each do |r|
      venv.pip_install r
    end

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
