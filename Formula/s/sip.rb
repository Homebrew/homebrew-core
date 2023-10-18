class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/a6/4e/c34eee70109e9a8110672f074fc18b5022bf4b9b4c92641245c73ae0b21a/sip-6.7.12.tar.gz"
  sha256 "08e66f742592eb818ac8fda4173e2ed64c9f2d40b70bee11db1c499127d98450"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6c26fe676b1b8f3bd3defd00af9c1f0669ed4ecd4abed1172bcc10a47549d9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33ff5ada50bee46445c9f4746afd774934a5e6e5328e24dde70f69a848cf34c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80704ca8d3fcadbbe533dd6b903000175bc51b8823524c04da7b224a17cdf6e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "360cfb5725b27debb80303d4975a5810216a29810cd93491fe9eed3be631c261"
    sha256 cellar: :any_skip_relocation, ventura:        "94091f9d59c1e1483583fbfbddf4bc383b6cea12eac9c966ad3566a36fb92666"
    sha256 cellar: :any_skip_relocation, monterey:       "11e266fda148ea5baf55790d8b4176eaa4badf2e4cda935045244ea810e7cee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51cf2961ec9151868881bf580fc8bc2af96cfe72ab338e4db8f12acdc68e11fd"
  end

  depends_on "python-packaging"
  depends_on "python@3.11"

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
