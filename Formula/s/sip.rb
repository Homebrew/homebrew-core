class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/ce/8c/f66d1c45946e73a46f258b9628fe974ba8cc46c41b4750a59be192981695/sip-6.7.11.tar.gz"
  sha256 "f0dc3287a0b172e5664931c87847750d47e4fdcda4fe362b514af8edd655b469"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8814668c87731981503fa8fa6a9a4adbd6ad426bb77facaec71467f56d3cac27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bec8f6bf863d61e419ed70df4866cc61016495477120635a78f063567c5d635"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b09056383526598637b3021f7e3ae445b81f5a551862eee15eeb4518da24974b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e9cb65bf16e4be9061d89d199f9fe7cf02150f9c76ff535598ea27d5cc0d048"
    sha256 cellar: :any_skip_relocation, ventura:        "3e3bd6426baabeacc440e4298ebe93af84d65ce508ff01d52699b15192749411"
    sha256 cellar: :any_skip_relocation, monterey:       "e0486146e9ed3a3e1c487dbdbba0be652b5b96b0b08d29211ee11f3dd631a029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a3c76fe0ff0ed10eeeff8a1bd4fcdf8af38bd92cc7bf888a8e7a92506cc50b3"
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
