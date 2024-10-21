class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/b4/61/0228586a10b76064431e1d0c965f030b4c7dfbea6d1cfcb4d3f0cb0e6726/snakefmt-0.10.2.tar.gz"
  sha256 "4286a5903b66da7e52763c5e8184da4edc95113b758f4448528804fb54f9b75a"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11f68240857d9f3b6633e324772ebfa6e0c3ad0b428848d8fec8ef7fc138e887"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11f68240857d9f3b6633e324772ebfa6e0c3ad0b428848d8fec8ef7fc138e887"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11f68240857d9f3b6633e324772ebfa6e0c3ad0b428848d8fec8ef7fc138e887"
    sha256 cellar: :any_skip_relocation, sonoma:        "eabb13081318cb5879ccf641dd404b84631431db0451b50327aeb4c22c96defc"
    sha256 cellar: :any_skip_relocation, ventura:       "eabb13081318cb5879ccf641dd404b84631431db0451b50327aeb4c22c96defc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69070a7b66ff5fa9529bd30d05db583218ac848c945e463e5fc5c68a9d16ddc2"
  end

  depends_on "python@3.13"

  resource "black" do
    url "https://files.pythonhosted.org/packages/d8/0d/cc2fb42b8c50d80143221515dd7e4766995bd07c56c9a3ed30baf080b6dc/black-24.10.0.tar.gz"
    sha256 "846ea64c97afe3bc677b761787993be4991810ecc7a4a937816dd6bddedc4875"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"Snakefile"
    test_file.write <<~EOS
      rule testme:
          output:
               "test.out"
          shell:
               "touch {output}"
    EOS
    test_output = shell_output("#{bin}/snakefmt --check #{test_file} 2>&1", 1)
    assert_match "[INFO] 1 file(s) would be changed 😬", test_output

    assert_match "snakefmt, version #{version}",
      shell_output("#{bin}/snakefmt --version")
  end
end
