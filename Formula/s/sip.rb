class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://python-sip.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/6e/52/36987b182711104d5e9f8831dd989085b1241fc627829c36ddf81640c372/sip-6.8.6.tar.gz"
  sha256 "7fc959e48e6ec5d5af8bd026f69f5e24d08b3cb8abb342176f5ab8030cc07d7a"
  license "BSD-2-Clause"
  head "https://github.com/Python-SIP/sip.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dcb80371d8d2a7e940566060a8808cd6debcc403ab46b75e605715be8f775b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dcb80371d8d2a7e940566060a8808cd6debcc403ab46b75e605715be8f775b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1dcb80371d8d2a7e940566060a8808cd6debcc403ab46b75e605715be8f775b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e1e1de1fa68a594442699d1ad606342b5acc01441d3011d6908abe02604d985"
    sha256 cellar: :any_skip_relocation, ventura:       "7e1e1de1fa68a594442699d1ad606342b5acc01441d3011d6908abe02604d985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "231c036c97e370aa86a8a80c3fb1720a05f0a13d5f6cc62edf048764dd90c8a7"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
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

    system bin/"sip-install", "--target-dir", "."
  end
end
