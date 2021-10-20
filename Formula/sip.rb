class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/ed/74/57851ed1cd8d996bbb3103b17798d59ddda3f7f8245b826c01aadfc3d66c/sip-6.3.1.tar.gz"
  sha256 "2f9cd6ce0e19226d53d62ad6ba81a62f624626f14924724eab2a23390d4dc684"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "933b936d56d79aa7f1f044f0b7cfc53b61fbbba541243bf73d76c1308040fdfc"
    sha256 cellar: :any_skip_relocation, big_sur:       "78d4beda8f0e902311c19eace9723a805d37aa978053b20198bfc29b2fb43e17"
    sha256 cellar: :any_skip_relocation, catalina:      "7fdf440cd1060a7a58c686dd7568d9984c9950abd7eb52ac5585badcf878e97d"
    sha256 cellar: :any_skip_relocation, mojave:        "d34a94def987327458aabd27b6c10dee5efb165f51355ba9987ecf94c80e559b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03835651221c839d3139c3a67c762985517e10b48da714c69ac4936d3d5e40a1"
  end

  depends_on "python@3.9"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/86/aef78bab3afd461faecf9955a6501c4999933a48394e90f03cd512aad844/packaging-21.0.tar.gz"
    sha256 "7dc96269f53a4ccec5c0670940a4281106dd0bb343f47b7471f779df49c2fbe7"
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
