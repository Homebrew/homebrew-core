class Virgil < Formula
  desc "CLI tool to manage your Virgil account and applications"
  homepage "https://github.com/VirgilSecurity/virgil-cli"
  url "https://github.com/VirgilSecurity/virgil-cli.git",
     tag:      "v5.2.9",
     revision: "604e4339d100c9cd133f4730ba0efbd599321ecb"
  license "BSD-3-Clause"
  head "https://github.com/VirgilSecurity/virgil-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "6ad1a2ee3c09e0ea3ae2027c7a35a26a9ab048ba3b3454072bc47ff2f144a7dc"
    sha256 cellar: :any_skip_relocation, big_sur:      "e9ce86f5569a014b80c43e5bdf3d16aed3fc81c3e6fe4841e0b649f6d07542d3"
    sha256 cellar: :any_skip_relocation, catalina:     "841082fa11c796ba0045d4ced3cead342fba308b049f07db4a0bd3309acc08c7"
    sha256 cellar: :any_skip_relocation, mojave:       "d115016c280fbfe9381b56d0e08b9a69b4dc62042bb73424c243ea3f73280cd9"
    sha256 cellar: :any_skip_relocation, high_sierra:  "f7b6c179875ab30f849e3cbba53c8aeed7af4c569b69d4b112c2d749e5c38ea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "05da77ebed1e01c11281b7f148441a6aa22f9be8d219037913c238d95c615425"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "virgil"
  end

  test do
    result = shell_output "#{bin}/virgil purekit keygen"
    assert_match "SK.1.", result
  end
end
