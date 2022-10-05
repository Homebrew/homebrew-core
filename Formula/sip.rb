class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/28/09/87e20f2be19051bea42df699947aba30f84422908ec2b8d827bcdf0ab365/sip-6.7.1.tar.gz"
  sha256 "28170fdf880f937026fc87faa9c177b062c353c5d169ea3242b07802614ddd0c"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9459221b69cbe3b8bc008a9d8be04ab55db0a5fd219c89c2e9c819ceafede438"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a46c210b1bd3ac9c3f6114bbac758b5915df6bdf0b066a4e097defc06b59943f"
    sha256 cellar: :any_skip_relocation, monterey:       "a074c65f1a0066a5a8855eb71717c092a498396d558f6cf579fa98f11ab4019d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d20181ebf36bc5c2b8a00e8771f84306f69e79cfb1cfc2665c9c6ee8dc2f3e30"
    sha256 cellar: :any_skip_relocation, catalina:       "cd4790a3e480323e36b54cb20f6af79dc61645f96f00416a55a4736ed625f716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc1309968cca5634bdcbfbd149830c9f877f6e5942596303895d8b1215470a13"
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
