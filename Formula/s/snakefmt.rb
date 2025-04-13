class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/66/da/0411e11ff46a9706539b1215ecf4afa3e5bc2da60e4caa8cc23177044e6a/snakefmt-0.11.0.tar.gz"
  sha256 "afc3b92e103cfda80fff7e77f357f6cc1dab742272ee76342ba342f30e721f30"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6f3b238883159ea5e23d01cb0892963b4bd953d24c1698012b53bc5f26a9c4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6f3b238883159ea5e23d01cb0892963b4bd953d24c1698012b53bc5f26a9c4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6f3b238883159ea5e23d01cb0892963b4bd953d24c1698012b53bc5f26a9c4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b5c55a0907942d9ce338e1a2edab23febf8e9fd3d6411c6310ace4c1e2784bb"
    sha256 cellar: :any_skip_relocation, ventura:       "7b5c55a0907942d9ce338e1a2edab23febf8e9fd3d6411c6310ace4c1e2784bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1630f33ef1dea71add311265206881e08a08e00ce2f9fb866a5c97d1eb1fd09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1630f33ef1dea71add311265206881e08a08e00ce2f9fb866a5c97d1eb1fd09"
  end

  depends_on "python@3.13"

  resource "black" do
    url "https://files.pythonhosted.org/packages/d8/0d/cc2fb42b8c50d80143221515dd7e4766995bd07c56c9a3ed30baf080b6dc/black-24.10.0.tar.gz"
    sha256 "846ea64c97afe3bc677b761787993be4991810ecc7a4a937816dd6bddedc4875"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b6/2d/7d512a3913d60623e7eb945c6d1b4f0bddf1d0b7ada5225274c87e5b53d1/platformdirs-4.3.7.tar.gz"
    sha256 "eb437d586b6a0986388f0d6f74aa0cde27b48d0e3d66843640bfb6bdcdb6e351"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    # The source doesn't have a valid SOURCE_DATE_EPOCH, so here we set default.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"snakefmt", shells: [:fish, :zsh], shell_parameter_format: :click)
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
