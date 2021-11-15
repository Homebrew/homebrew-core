class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/c4/de/76c2927ea8f74dc4909c9affeba4c0191c43a4aefbe2118cc69b2cbd8461/sip-6.4.0.tar.gz"
  sha256 "42ec368520b8da4a0987218510b1b520b4981e4405086c1be384733affc2bcb0"
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
    url "https://files.pythonhosted.org/packages/4d/34/523195b783e799fd401ad4bbc40d787926dd4c61838441df08bf42297792/packaging-21.2.tar.gz"
    sha256 "096d689d78ca690e4cd8a89568ba06d07ca097e3306a4381635073ca91479966"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
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
