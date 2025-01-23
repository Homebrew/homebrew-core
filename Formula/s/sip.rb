class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://python-sip.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/e2/83/b23f610ef99fa23aa3c8dcd2ff8536c37b943654405ff4f45f3230327a40/sip-6.9.1.tar.gz"
  sha256 "7904be5190d7879952563b78a3af0e58fa27d9525af7f53f93eac7a83b433e7b"
  license "BSD-2-Clause"
  head "https://github.com/Python-SIP/sip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa15876caa8cb425d1aa7b83a91bce73af45621d373cce6febe2622c39649875"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa15876caa8cb425d1aa7b83a91bce73af45621d373cce6febe2622c39649875"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa15876caa8cb425d1aa7b83a91bce73af45621d373cce6febe2622c39649875"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f857b0b03025a3fdc47792bdd3a6e1124fc83b2901560a9963c88cd095ef290"
    sha256 cellar: :any_skip_relocation, ventura:       "9f857b0b03025a3fdc47792bdd3a6e1124fc83b2901560a9963c88cd095ef290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c09df641c9f1b3f4c19361c6313c2219cea6153465db5e8a1e333a16707cd97e"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/43/54/292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0/setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
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
