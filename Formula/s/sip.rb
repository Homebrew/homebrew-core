class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  # upstream page 404 report, https://github.com/Python-SIP/sip/issues/7
  homepage "https://python-sip.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/99/85/261c41cc709f65d5b87669f42e502d05cc544c24884121bc594ab0329d8e/sip-6.8.3.tar.gz"
  sha256 "888547b018bb24c36aded519e93d3e513d4c6aa0ba55b7cc1affbd45cf10762c"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 1
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8a96a93f510ddbe558aa9ac3cd409126a2bafa005c8a334328030c2fa643b91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8a96a93f510ddbe558aa9ac3cd409126a2bafa005c8a334328030c2fa643b91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8a96a93f510ddbe558aa9ac3cd409126a2bafa005c8a334328030c2fa643b91"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9c822914a37d8362ab7582870b8830a605b9590b8c63cf2d9ddde07a42bb1d8"
    sha256 cellar: :any_skip_relocation, ventura:        "d9c822914a37d8362ab7582870b8830a605b9590b8c63cf2d9ddde07a42bb1d8"
    sha256 cellar: :any_skip_relocation, monterey:       "d9c822914a37d8362ab7582870b8830a605b9590b8c63cf2d9ddde07a42bb1d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaf8061f357e4585fb6ac812bf9b2ba756a5f5e3db6f6024f92f41a88b9d718e"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4d/5b/dc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83d/setuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  def install
    python3 = "python3.12"
    venv = virtualenv_install_with_resources

    # Modify the path sip-install writes in scripts as we install into a
    # virtualenv but expect dependents to run with path to Python formula
    inreplace venv.site_packages/"sipbuild/builder.py", /\bsys\.executable\b/, "\"#{which(python3)}\""
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
