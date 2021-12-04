class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/07/4e/0de6d5872145f4cedf187aa8a9069ba91d7e293a82cbbaeabd10c45e9cf0/sip-6.5.0.tar.gz"
  sha256 "a1cf8431a8eb9392b3ff6dc61d832d0447bfdcae5b3e4256a5fa74dbc25b0734"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41319912eb41049687a2517e23456b2930b95601ee3410bccf281b06e2b8e79d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "387df7be9c247422535f833546f09f9f96654fa7ade49e7a5363e9fb9037bf88"
    sha256 cellar: :any_skip_relocation, monterey:       "298c058e8b26acc12e877e0493824f1176477880a6355ed625ee30d8d49c1194"
    sha256 cellar: :any_skip_relocation, big_sur:        "33425991aeb9c71b0f94fb532bfacde258c01af6474749d8d2f99f45f426d489"
    sha256 cellar: :any_skip_relocation, catalina:       "a8fdec4f61e9c8d5b1b1e4444987b697ae432d1052db071687f78202f5484a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa484e6db066b5017fae3a80fe0b2cfe03515f1a875a46143c7df6e3fdf56e8b"
  end

  depends_on "python@3.9"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/ab/61/1a1613e3dcca483a7aa9d446cb4614e6425eb853b90db131c305bd9674cb/pyparsing-3.0.6.tar.gz"
    sha256 "d9bdec0013ef1eb5a84ab39a3b3868911598afa494f5faa038647101504e2b81"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
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
