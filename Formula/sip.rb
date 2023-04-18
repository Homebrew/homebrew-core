class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/c7/09/68bfefcdc48875e66aabafc946620483d0cd93aba52dde37d2059e5bf927/sip-6.7.8.tar.gz"
  sha256 "7e7186a36818c9d325c82e59ac5b049d9022c2d5783942c38d49497ac8a94c8f"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c8342758f17b10361617472d7e3c99d5db4921cd1343fafe56ff6129d4507dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13b0b3b4ccbb7521483a4d8b482be13253151e4dd4b60ea4aa49ac26a349bc4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84445dc23b83a2b2bac6a9a82f9bf28a900ce6944b14df6dddfca8b873b4555a"
    sha256 cellar: :any_skip_relocation, ventura:        "bd84100e14df079ab132e82e7c5ea6bef5c5db9325d2bb04d303603168a2a77c"
    sha256 cellar: :any_skip_relocation, monterey:       "264883a813ca3436a606ece331a54d0103a744a57529eeb30dc51bce589deb3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d6c552b25c05d7c2987772d59d7b3b71d8ec338ef1a8a87b890195974e7bc4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cd94f1435fc4aa35e3378040812dde4eef157766dca044027b507f18dc6807f"
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
