class SolcSelect < Formula
  include Language::Python::Virtualenv

  desc "Manage multiple Solidity compiler versions"
  homepage "https://github.com/crytic/solc-select"
  url "https://files.pythonhosted.org/packages/48/d6/35f72b61b89c087e7b886ff6511deb6d3193db2ffacdcf03827373e5e312/solc-select-0.2.1.tar.gz"
  sha256 "e956b04dc7df2209d1fb3b82e2bb62f8e730bb554c4d7f958a14ff2fb2f37212"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/solc-select.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ac26c04b812edb78827ea157922a2632f41baeeea46b96d327d5e3b4c639c51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24eb3aabb941f8485012e6b704e314b601665eb20d1b61ca6426146af2cf7bff"
    sha256 cellar: :any_skip_relocation, monterey:       "422f46f5951b13ce2f9e086c682f346022331e93cf5a4f5fc560d21a35873ba3"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6d93a849a523b5cbf3fe6f7e734f67559b22088483d08123f21c981c4a556fd"
    sha256 cellar: :any_skip_relocation, catalina:       "1246f1990006e4193db239da796b9c16600dc9f4b55fe1dbcbd7fe6620f4ab5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a730fa2e00e4139307726ad8102f655dc5211da8dc5093670f5f7a66ce55d3f"
  end

  depends_on "python@3.10"

  resource "pysha3" do
    url "https://files.pythonhosted.org/packages/73/bf/978d424ac6c9076d73b8fdc8ab8ad46f98af0c34669d736b1d83c758afee/pysha3-1.0.2.tar.gz"
    sha256 "fe988e73f2ce6d947220624f04d467faf05f1bbdbc64b0a201296bb3af92739e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"solc-select", "install", "0.5.7"
    system bin/"solc-select", "install", "0.8.0"
    system bin/"solc-select", "use", "0.5.7"

    assert_match("0.5.7", shell_output("#{bin}/solc --version"))
    with_env(SOLC_VERSION: "0.8.0") do
      assert_match("0.8.0", shell_output("#{bin}/solc --version"))
    end
  end
end
