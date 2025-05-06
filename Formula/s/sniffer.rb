class Sniffer < Formula
  desc "Modern alternative network traffic sniffer"
  homepage "https://github.com/chenjiandongx/sniffer"
  url "https://github.com/chenjiandongx/sniffer/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "8da1a20155518da7c195fd370ab2811d02eddcfc11f423f75335f7b8024d42f0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1e4896b43b3ea3b7a8065fd9de52737c9e56adef3b5aa8cbe7e05b29fafbb725"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5aac7f08562aeaef83c298a129f8749a3c94f37ed31a771c0fb098fb9926c1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "426df2385cf9a2725bb85856e9e825177c7ebfba07baf662f7e15c03cb934d18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14357cfb10b5c6a0dfd256265b0a15381696714e841bb88bceb59b0c1d8f0ed8"
    sha256 cellar: :any_skip_relocation, sonoma:         "0039e5ac0e23ec4990badeae4d3adc5d244de339060b7c92991716751b1d1239"
    sha256 cellar: :any_skip_relocation, ventura:        "257d8ea96ca570d8040cb01613c103836f6620cd0e07759e93cf7df891a40f6f"
    sha256 cellar: :any_skip_relocation, monterey:       "721dde5fd616c6255cafbf6fb65d27459579829b92dc7d59c3b2638e6e9394d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9380e8bab28258abc9fba37619c04a54c2a9e6b91d847d2ab5a643a1a47e2f2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b01bfd9aa799259150ec8dd50050d4787b6410377ba2c62b93b0dc157c182f5b"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "lo", shell_output("#{bin}/sniffer -l")
  end
end
