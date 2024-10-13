class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://python-sip.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/6e/52/36987b182711104d5e9f8831dd989085b1241fc627829c36ddf81640c372/sip-6.8.6.tar.gz"
  sha256 "7fc959e48e6ec5d5af8bd026f69f5e24d08b3cb8abb342176f5ab8030cc07d7a"
  license "BSD-2-Clause"
  head "https://github.com/Python-SIP/sip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8d0d884c04dce2c1c0aeb068804ab6cabfca418eaacc1124797f5e678e154716"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba635ba462ce21105b7e3782421c7a40c7b6a554178144be0acba3bb8031decf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba635ba462ce21105b7e3782421c7a40c7b6a554178144be0acba3bb8031decf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba635ba462ce21105b7e3782421c7a40c7b6a554178144be0acba3bb8031decf"
    sha256 cellar: :any_skip_relocation, sonoma:         "20dba74bbafa429c4fb25e5c42828cef2f3ff9be981e6ab7c8589d65a01db7c4"
    sha256 cellar: :any_skip_relocation, ventura:        "20dba74bbafa429c4fb25e5c42828cef2f3ff9be981e6ab7c8589d65a01db7c4"
    sha256 cellar: :any_skip_relocation, monterey:       "20dba74bbafa429c4fb25e5c42828cef2f3ff9be981e6ab7c8589d65a01db7c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "809c6158e572522f9e427ed3100b8a5c9a5a0389a803d11f9d5b0592ee6e0a90"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/65/d8/10a70e86f6c28ae59f101a9de6d77bf70f147180fbf40c3af0f64080adc3/setuptools-70.3.0.tar.gz"
    sha256 "f171bab1dfbc86b132997f26a119f6056a57950d058587841a0082e8830f9dc5"
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

    system bin/"sip-install", "--target-dir", "."
  end
end
