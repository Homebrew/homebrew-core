class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/48/75/98987181e897ef378d6c239ee733328a7264a41f2d8263e61d7b7c4c0909/sip-6.7.9.tar.gz"
  sha256 "35d51fc10f599d3696abb50f29d068ad04763df7b77808c76b74597660f99b17"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b07e5b650d400e9a097966aa33e682cc9e615e1be41c811a13207af34d147c04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6eafb58e8e27af7e0d854217c23ebf828f8ee9baca763d967df9d08a9c927032"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ad868f403fc2427904da6d8fab0f2af6cfd3e3aeb9e20f3cbc81a6e1a4231c1"
    sha256 cellar: :any_skip_relocation, ventura:        "2e58cd885ac632d62792c6d4f423b4524f5a766d344536a71a0fe11e71337f70"
    sha256 cellar: :any_skip_relocation, monterey:       "4361970df0241af1e8d864c05e57e180c45f4c5f5168234fece3c9c730187b80"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cd6e3acd78447f5eedeb2e72f01654152471b23472d5a4896a0cf73242a250d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "554cac25ac96b244a210eb59b1dac24ef1d624cc3279a17aab87b8bb12c5dc08"
  end

  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
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

    system "#{bin}/sip-install", "--target-dir", "."
  end
end
