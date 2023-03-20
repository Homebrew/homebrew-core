class SlitherAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Solidity static analysis framework written in Python 3"
  homepage "https://github.com/crytic/slither"
  url "https://files.pythonhosted.org/packages/9c/d1/ac5d4b486a1e9528158127630193e874b8b8a7874a9387b6a812d48d2086/slither-analyzer-0.9.2.tar.gz"
  sha256 "625ef0c18b9484e4be094ea3d2b15649f93d8724f165d4d6f9adc8ccddf6ebcf"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/slither.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99181f036b6aac897211d0084a2ae0fa87e362b669262612195fccebca422899"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "180f38830950c001b7924f0916d83486c25be275a323a6801b40829dd6fe899e"
    sha256 cellar: :any_skip_relocation, ventura:        "ee78fe2ca9144fc925158198a933bcf87f6fc43d6a49d727868cab8885ddb4b6"
    sha256 cellar: :any_skip_relocation, monterey:       "4fb008d09e32a26c4ebe4fcaa65c496c3d631d7a73c421269ee0edc5e68542c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7864391e19f0f34765ae42f299f0ccdc009beff457fdc6dfef13f47be5f1045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16fca5f312118c3c669427b0edb3613baa3e5c2304f6081373c14501c3ac0b9e"
  end

  depends_on "crytic-compile"
  depends_on "python@3.11"
  depends_on "solc-select"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/ba/b6/8e78337766d4c324ac22cb887ecc19487531f508dbf17d922b91492d55bb/prettytable-3.6.0.tar.gz"
    sha256 "2e0026af955b4ea67b22122f310b90eae890738c08cb0458693a49b6221530ac"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
    site_packages = Language::Python.site_packages("python3.11")
    crytic_compile = Formula["crytic-compile"].opt_libexec
    (libexec/site_packages/"homebrew-crytic-compile.pth").write crytic_compile/site_packages
  end

  test do
    (testpath/"test.sol").write <<~EOS
      pragma solidity ^0.8.0;
      contract Test {
        function incorrect_shift() internal returns (uint a) {
          assembly {
            a := shr(a, 8)
          }
        }
      }
    EOS

    system "solc-select", "install", "0.8.0"

    with_env(SOLC_VERSION: "0.8.0") do
      # slither exits with code 255 if high severity findings are found
      assert_match("1 result(s) found",
                   shell_output("#{bin}/slither --detect incorrect-shift --fail-high #{testpath}/test.sol 2>&1", 255))
    end
  end
end
