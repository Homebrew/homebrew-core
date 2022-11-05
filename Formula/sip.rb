class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/08/f6/06ad8d62331b302b68fbd730eedec8346213db71857128cb3b8309fee2ad/sip-6.7.4.tar.gz"
  sha256 "9dbf8a0e7c8d76d1642e2fdd3f53e6a522f7c30980e527763c45760c2505cfbf"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cc0ede71faa7f49eb98813b1f08a254357cf51edfb16ab784d429a63b2013a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b633c40ff64a6c4a7faed5364a093b1d5a6e5033d65580cd82b70a2964d30db5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c65a3f809b71a0bbbf2a31a78670db919e22c8862359ea2139fa57de38b2cc9"
    sha256 cellar: :any_skip_relocation, monterey:       "ecb0060b54236fdee4de269ef883f59cb1a53876a88a4e3905b5929435983eaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "29669c5102c44f9bf9d566dfa6f13221bd49d60839fbd3059146b43ca8f51732"
    sha256 cellar: :any_skip_relocation, catalina:       "8a517f98293aefcbdea02db7ddeaca7dec2027681f655e1b2e46441e83c95594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c25bda6cbf3c46ad83319b2f7de9c2126148d216ab98751a0bfbbb1ee37c9abe"
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
