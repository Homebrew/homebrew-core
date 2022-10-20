class SlitherAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Solidity static analysis framework written in Python 3"
  homepage "https://github.com/crytic/slither"
  url "https://files.pythonhosted.org/packages/63/fe/1e7b29ed341a8ad032cb75705d0ff77bc1dc9700cb447b97c6a63693c373/slither-analyzer-0.9.0.tar.gz"
  sha256 "bb37ebde30b24ed6c933d575fe34d2d92581ab748eb8c9030ce60543cbc2e132"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/slither.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a36b4b27533c9c041417869fd627f589ac8566e7d0e12160e5b2fef5c64982a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa72383803b6bcec85488ad3986b5af439bbd0146f83d78f2fd4376fa462974a"
    sha256 cellar: :any_skip_relocation, monterey:       "2ac359b6e3a67e1998f9372fd45a83d1715a148e93abd5cce1fc99b24601a3da"
    sha256 cellar: :any_skip_relocation, big_sur:        "93664bbd482ab3adbbafc819d4218686d60dce3007f5aaaafd39e29eab4a0d79"
    sha256 cellar: :any_skip_relocation, catalina:       "d688d3e6553845fa05b13df66a41abf80dc07df33326bd12e4c229b420bae590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "103d9f05a63a9170d7455b932e99a2422f8ec17e9c6daefc57c4338202c5ec53"
  end

  depends_on "crytic-compile"
  depends_on "python@3.10"
  depends_on "solc-select"

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/a5/aa/0852b0ee91587a766fbc872f398ed26366c7bf26373d5feb974bebbde8d2/prettytable-3.4.1.tar.gz"
    sha256 "7d7dd84d0b206f2daac4471a72f299d6907f34516064feb2838e333a4e2567bd"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
    site_packages = Language::Python.site_packages("python3.10")
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
