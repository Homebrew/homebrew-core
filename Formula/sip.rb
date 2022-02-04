class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/de/c1/9ac5596c10f6ce28abc1849ed1b6299b3953af0b6ff21e227024991a517e/sip-6.5.1.tar.gz"
  sha256 "204f0240db8999a749d638a987b351861843e69239b811ec3d1881412c3706a6"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "679ab5ed54d08cd2c73b83580061d4458da33fd7670b206c43a9ed55a787b900"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27edf0c915d0f92a6618e4cb02f700152890aba90cb0860d70cf21b47e36a3bc"
    sha256 cellar: :any_skip_relocation, monterey:       "4ddcf1aa1e86bfe6cf560c1280524543057cef2cc18e855ebd91e939a794b0f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bc3fed653bb7f9db814eaf37b8ee7e3fbbf4515f7ed9c5dc5fef98a989d7beb"
    sha256 cellar: :any_skip_relocation, catalina:       "951a9b7ecdf226b80238c81d9c90879f11f520e78749bdde278d25b8db705631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f01fcca9f49930582b3fb5c923093a9e087f74a0cd1d319f41533370d8758b69"
  end

  depends_on "python@3.9"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/d6/60/9bed18f43275b34198eb9720d4c1238c68b3755620d20df0afd89424d32b/pyparsing-3.0.7.tar.gz"
    sha256 "18ee9022775d270c55187733956460083db60b37d0d0fb357445f3094eed3eea"
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
