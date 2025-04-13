class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://python-sip.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/62/9a/78122735697dbfc6c1db363627309eb0da7e44d8c05ba017b08666530586/sip-6.10.0.tar.gz"
  sha256 "fa0515697d4c98dbe04d9e898d816de1427e5b9ae5d0e152169109fd21f5d29c"
  license "BSD-2-Clause"
  head "https://github.com/Python-SIP/sip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2ee78b3a93a1f0ae7469573129b6fc6cf2c940fdff3167fdccb8a5ec4c52e45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2ee78b3a93a1f0ae7469573129b6fc6cf2c940fdff3167fdccb8a5ec4c52e45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2ee78b3a93a1f0ae7469573129b6fc6cf2c940fdff3167fdccb8a5ec4c52e45"
    sha256 cellar: :any_skip_relocation, sonoma:        "66616e4055c5d84151c5f985b4fe76e6df1b73745199b904e7ac31fab60b2617"
    sha256 cellar: :any_skip_relocation, ventura:       "66616e4055c5d84151c5f985b4fe76e6df1b73745199b904e7ac31fab60b2617"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5023f74a18936d667bd5899310ef260882732dfccfbcb477f2a791e34b4f06d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12654418be62fe1ac65a57450710c5f9b5166056859601786c458d0d4ad62424"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/92/ec/089608b791d210aec4e7f97488e67ab0d33add3efccb83a056cbafe3a2a6/setuptools-75.8.0.tar.gz"
    sha256 "c5afc8f407c626b8313a86e10311dd3f661c6cd9c09d4bf8c15c0e11f9f2b0e6"
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
