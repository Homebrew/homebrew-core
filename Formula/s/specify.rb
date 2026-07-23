class Specify < Formula
  include Language::Python::Virtualenv

  desc "Toolkit to help you get started with Spec-Driven Development"
  homepage "https://github.github.com/spec-kit/"
  url "https://github.com/github/spec-kit/archive/refs/tags/v0.13.4.tar.gz"
  sha256 "9e18def2179cb2d652972758bef8f119dc7cbf0cfd855f66fe3fa01d942451fc"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "de1b63274bf1a139bee9bd91a3a3a2a81e43ae5a7b07f98fd59c5c9510c8af01"
    sha256 cellar: :any, arm64_sequoia: "2e3feff70278dfd135ebaad2b41eb0d87a17f714ec499fec5fe062b9d033c714"
    sha256 cellar: :any, arm64_sonoma:  "a9d5806403d9409e7a7f96417be94050f79a8d21b46feca96944d6eb03cf6864"
    sha256 cellar: :any, sonoma:        "1f08c68062d746916cbc0d3607fe3f10bdb299b0f43280f099d54bc31594505d"
    sha256 cellar: :any, arm64_linux:   "9114942f3f080d41f761880441f0f9add46fdb81aec2993728ac9591e8aea8b7"
    sha256 cellar: :any, x86_64_linux:  "510866ce2f957f98d0a1d29e1b93b899ba5a9c9f7532469fcdb59c3040a2430b"
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
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/e4/7d/05c46a96a78147ae3bf99c2f4169ce144a70220b8d6fcd56f6ec368b8ce9/json5-0.15.0.tar.gz"
    sha256 "7424d1f1eb1d56da6e3d70643f53619862b4ce81440bdb8ecfd6f875e5ba4a71"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
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
    url "https://files.pythonhosted.org/packages/52/cd/4f25b2f95b23f5d2c9c1fe43e49841bff5800562149b2666afc09309aa8f/platformdirs-4.10.1.tar.gz"
    sha256 "ceab4084426fe6319ce18e86deada8ab1b7487c7aee7040c55e277c9ae793695"
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
    url "https://files.pythonhosted.org/packages/37/78/fda3361b56efc27944f24225f6ecd13d96d6fcfe37bd0eb34e2f4c63f9fc/typer-0.27.0.tar.gz"
    sha256 "629bd12ea5d13a17148125d9a264f949eb171fb3f120f9b04d85873cab054fa5"
  end

  def install
    # Turn on shell completions option
    inreplace "src/specify_cli/__init__.py", "add_completion=False", "add_completion=True"

    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"specify", shell_parameter_format: :typer)
  end

  test do
    system bin/"specify", "init", "test-project", "--integration", "copilot", "--script", "sh", "--ignore-agent-tools"
    assert_path_exists testpath/"test-project/.specify/memory/constitution.md"

    assert_match "Specify CLI is ready to use", shell_output("#{bin}/specify check")
  end
end
