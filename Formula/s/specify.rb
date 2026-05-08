class Specify < Formula
  include Language::Python::Virtualenv

  desc "Toolkit to help you get started with Spec-Driven Development"
  homepage "https://github.com/github/spec-kit"
  url "https://github.com/github/spec-kit/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "401df81dc721576e2e23ea150f94d9227341b7ac3556b7e4ae89c20d45437e8c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "890e85efdc7e74ee9a25ea82c616b54bd6cdb8002d1585d412306046a3ac9276"
    sha256 cellar: :any,                 arm64_sequoia: "f7ec4223c9d03ac8105c7512fc4b275c6794594b4cbd201bb49925960408b4b8"
    sha256 cellar: :any,                 arm64_sonoma:  "90f009998ef61ce1b9b2706516d495208140eaab97b3253ee85d09600325ea7c"
    sha256 cellar: :any,                 sonoma:        "0f0b0864fb7894bf1d485d35cdab2bd3199d9a62099e8007a18b2660986768e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdee60d74d44b1b2109ccb1912d2dd33677a0b36138a8f945d81ac66b563b2df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bce3d5a246948256166439a070cde3e9d9b44cc117b1165fc537cc597646a65c"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/9c/4b/6f8906aaf67d501e259b0adab4d312945bb7211e8b8d4dcc77c92320edaa/json5-0.14.0.tar.gz"
    sha256 "b3f492fad9f6cdbced8b7d40b28b9b1c9701c5f561bef0d33b81c2ff433fefcb"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5c/5c/f3aedc83549aae71cd52b9e9687fe896e3dc6e966ba20eba04718605d198/markdown_it_py-4.1.0.tar.gz"
    sha256 "760e3f87b2787c044c5138a5ba107b7c2be26c03b13cc7f8fe42756b65b1df6c"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "readchar" do
    url "https://files.pythonhosted.org/packages/ed/49/a10341024c45bed95d13197ec9ef0f4e2fd10b5ca6e7f8d7684d18082398/readchar-4.2.2.tar.gz"
    sha256 "e3b270fe16fc90c50ac79107700330a133dd4c63d22939f5b03b4f24564d5dd8"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/e4/51/9aed62104cea109b820bbd6c14245af756112017d309da813ef107d42e7e/typer-0.25.1.tar.gz"
    sha256 "9616eb8853a09ffeabab1698952f33c6f29ffdbceb4eaeecf571880e8d7664cc"
  end

  def install
    # Turn on shell completions option
    inreplace "src/specify_cli/__init__.py", "add_completion=False", "add_completion=True"

    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"specify", shell_parameter_format: :typer)
  end

  test do
    system bin/"specify", "init", "test-project", "--ai", "copilot", "--script", "sh", "--ignore-agent-tools"
    assert_path_exists testpath/"test-project/.specify/memory/constitution.md"

    assert_match "Specify CLI is ready to use", shell_output("#{bin}/specify check")
  end
end
