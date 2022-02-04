class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/de/c1/9ac5596c10f6ce28abc1849ed1b6299b3953af0b6ff21e227024991a517e/sip-6.5.1.tar.gz"
  sha256 "204f0240db8999a749d638a987b351861843e69239b811ec3d1881412c3706a6"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2d61003a071dce354d05965a547c91bf66f07b9af7c900702678a53a0c517ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "962f1435faca48c32eff68d404cb669f8f84d18db1389d61bbeb3ad79831d0a3"
    sha256 cellar: :any_skip_relocation, monterey:       "22ee129fd9070d060817e4d557502db912f33b4cb9858a573e20d52e130f59f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c37a3f5ac2c2362131936176630c36e1cb3fabd4dd8da9901e7b504da394ae5"
    sha256 cellar: :any_skip_relocation, catalina:       "ee891caf426740ed89764572e247832690ac1c6396fbbe98e91d2e25806a8d1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ab3f52d747db16cfb1f03187241b8cb152e43aeee9c688e11ca1fd9e64f5a42"
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
