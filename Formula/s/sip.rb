class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://python-sip.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/5b/62/f46c9a5634d4f9712721fe6f3c17ec19df89400c4fda3a9fd7e0f960f88e/sip-6.11.1.tar.gz"
  sha256 "3dae4baaf9e9f781d84bf293e0e2938dc7f44b826837889026eba53bd36c81b5"
  license "BSD-2-Clause"
  head "https://github.com/Python-SIP/sip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce4c69155ae1a5ec482636deb7ca18c592dc9f55c81a08ad203ca2665ac51ee0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce4c69155ae1a5ec482636deb7ca18c592dc9f55c81a08ad203ca2665ac51ee0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce4c69155ae1a5ec482636deb7ca18c592dc9f55c81a08ad203ca2665ac51ee0"
    sha256 cellar: :any_skip_relocation, sonoma:        "52a876478482491abbbb2921533ef70fc5e8b5cccc232406674d63345b24e5b9"
    sha256 cellar: :any_skip_relocation, ventura:       "52a876478482491abbbb2921533ef70fc5e8b5cccc232406674d63345b24e5b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c950820f47c4ea50e60161eb8a30c1e9e1ccc2c75a0a8d4d09a5a71da9ccfa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c950820f47c4ea50e60161eb8a30c1e9e1ccc2c75a0a8d4d09a5a71da9ccfa0"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/8d/d2/ec1acaaff45caed5c2dedb33b67055ba9d4e96b091094df90762e60135fe/setuptools-80.8.0.tar.gz"
    sha256 "49f7af965996f26d43c8ae34539c8d99c5042fbff34302ea151eaa9c207cd257"
  end

  def python3
    "python3.13"
  end

  def install
    venv = virtualenv_install_with_resources

    # Modify the path sip-install writes in scripts as we install into a
    # virtualenv but expect dependents to run with path to Python formula
    inreplace venv.site_packages/"sipbuild/builder.py", /\bsys\.executable\b/, "\"#{which(python3)}\""
  end

  test do
    (testpath/"pyproject.toml").write <<~TOML
      # Specify sip v6 as the build system for the package.
      [build-system]
      requires = ["sip >=6, <7"]
      build-backend = "sipbuild.api"

      # Specify the PEP 566 metadata for the project.
      [tool.sip.metadata]
      name = "fib"
    TOML

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

    system bin/"sip-install", "--target-dir", "."
  end
end
