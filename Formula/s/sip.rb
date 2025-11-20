class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://python-sip.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/a7/8a/869417bc2ea45a29bc6ed4ee82757e472f0c7490cf5b7ddb82b70806bce4/sip-6.14.0.tar.gz"
  sha256 "20c086aba387707b34cf47fd96d1a978d01e2b95807e86f8aaa960081f163b28"
  license "BSD-2-Clause"
  head "https://github.com/Python-SIP/sip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cf7a8de2a902dcb28039b9a9759bb255dc48a5b312d63aba075c7214e69d189"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cf7a8de2a902dcb28039b9a9759bb255dc48a5b312d63aba075c7214e69d189"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cf7a8de2a902dcb28039b9a9759bb255dc48a5b312d63aba075c7214e69d189"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2b704a9f45b1daad2ed8c3a0cc2e7c87e05707916dd9f635643d6c99c005809"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2b704a9f45b1daad2ed8c3a0cc2e7c87e05707916dd9f635643d6c99c005809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2b704a9f45b1daad2ed8c3a0cc2e7c87e05707916dd9f635643d6c99c005809"
  end

  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  def python3
    "python3.14"
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
