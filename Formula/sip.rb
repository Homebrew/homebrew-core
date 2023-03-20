class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/f1/ba/19f9cb16416a3c98bd5969b1bd9bf3c92dd278788d8d949ed66b8e0edf0d/sip-6.7.7.tar.gz"
  sha256 "dee9c06fa8ae6d441a401f922867fc6196edda274eebd9fbfec54f0769c2a9e2"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9793f0327511954b537d267e051bba7df2f675a17b72a5a70e605564f6bacb0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0916d65511a235c8e8305a810c886e2156b860255b55d88c424a2396e618c76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c614162f508071c3587307bb1ddd1fb2ba89883d9246ac29d08bdf07abbd08c3"
    sha256 cellar: :any_skip_relocation, ventura:        "74b5c890a4037adf40e14a04173eb5681b15be024f84a6613c1eb7c0fee294ca"
    sha256 cellar: :any_skip_relocation, monterey:       "2460291f97b2c7c4ef226948ab182d093b8740db201b86be56a34cfbbb3667c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2e56d3adbe5d32e01449cf9b436a3d73f259a24dcd131e3aaa1488652b7e419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7443f51aa60fba74ccc240d6caca37fd59ed79ce31aab6d757c8644584266985"
  end

  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
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

    system "sip-install", "--target-dir", "."
  end
end
