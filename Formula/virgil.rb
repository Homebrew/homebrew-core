class Virgil < Formula
  desc "CLI tool to manage your Virgil account and applications"
  homepage "https://github.com/VirgilSecurity/virgil-cli"
  url "https://github.com/VirgilSecurity/virgil-cli.git",
     :tag      => "v5.2.4",
     :revision => "46ad6eba489482a5eaff5ba89424f822525a6063"
  head "https://github.com/VirgilSecurity/virgil-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc2f75b6c78464e896f574abe240fc54dea029450ffcee2d2d087d0fc67c2091" => :catalina
    sha256 "f9ca3b004661ab12821c133655c5b50dc06ef0f18d444a5b8dc1a58dbc003b52" => :mojave
    sha256 "5398b66d72d5e25aaa3c10ef70818073a6cd3b38ecc688bdf0ee44979fcd5f1d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "virgil"
  end

  test do
    result = shell_output "#{bin}/virgil purekit keygen"
    assert_match /SK.1./, result
  end
end
