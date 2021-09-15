class RedTldr < Formula
  desc "Used to help red team staff quickly find the commands and key points"
  homepage "https://payloads.online/red-tldr/"
  url "https://github.com/Rvn0xsy/red-tldr/archive/v0.4.tar.gz"
  sha256 "47894a194da21e676901985909ba60c616f8b832df7e74834ae3f2da44b64b02"
  license "MIT"
  head "https://github.com/Rvn0xsy/red-tldr.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "privilege", shell_output("#{bin}/red-tldr search mimikatz")
  end
end
