class Virgil < Formula
  desc "CLI tool to manage your Virgil account and applications"
  homepage "https://github.com/VirgilSecurity/virgil-cli"
  url "https://github.com/VirgilSecurity/virgil-cli.git",
      tag:      "v5.2.9",
      revision: "604e4339d100c9cd133f4730ba0efbd599321ecb"
  license "BSD-3-Clause"
  head "https://github.com/VirgilSecurity/virgil-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "0d6baf5fbae58063f78f30264489c23a91179d000db777feb19d88d67786862d"
    sha256 cellar: :any_skip_relocation, ventura:      "933b5e559d600ae1953d8e627863ee64525bea81f11dd7cc87439471a1065625"
    sha256 cellar: :any_skip_relocation, monterey:     "6ad1a2ee3c09e0ea3ae2027c7a35a26a9ab048ba3b3454072bc47ff2f144a7dc"
    sha256 cellar: :any_skip_relocation, big_sur:      "e9ce86f5569a014b80c43e5bdf3d16aed3fc81c3e6fe4841e0b649f6d07542d3"
    sha256 cellar: :any_skip_relocation, catalina:     "841082fa11c796ba0045d4ced3cead342fba308b049f07db4a0bd3309acc08c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "05da77ebed1e01c11281b7f148441a6aa22f9be8d219037913c238d95c615425"
  end

  disable! date: "2025-03-02", because: :does_not_build

  depends_on "go" => :build
  # https://github.com/VirgilSecurity/virgil-cli/issues/58
  depends_on arch: :x86_64

  def install
    system "make"
    bin.install "virgil"
  end

  test do
    result = shell_output "#{bin}/virgil purekit keygen"
    assert_match "SK.1.", result
  end
end
