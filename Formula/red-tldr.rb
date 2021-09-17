class RedTldr < Formula
  desc "Used to help red team staff quickly find the commands and key points"
  homepage "https://payloads.online/red-tldr/"
  url "https://github.com/Rvn0xsy/red-tldr/archive/v0.4.2.tar.gz"
  sha256 "94cc5f195fac8617873f30616d65eba4b44b2ce4c58d7b6a5f8e2bbceef569f4"
  license "MIT"
  head "https://github.com/Rvn0xsy/red-tldr.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "privilege", shell_output("#{bin}/red-tldr mimikatz")
  end
end
