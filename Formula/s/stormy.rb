class Stormy < Formula
  desc "Minimal, customizable and neofetch-like weather CLI based on rainy"
  homepage "https://github.com/ashish0kumar/stormy"
  url "https://github.com/ashish0kumar/stormy/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "573c614ab5325e4238e1c6cc18a41e8fa1186b8379212e4c3840377f53ed1e3b"
  license "MIT"
  head "https://github.com/ashish0kumar/stormy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0385666c87702739a3f989df1116bbc10bc1331720b1ed3c0b330f70e86d9ecd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0385666c87702739a3f989df1116bbc10bc1331720b1ed3c0b330f70e86d9ecd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0385666c87702739a3f989df1116bbc10bc1331720b1ed3c0b330f70e86d9ecd"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe6d8d942bdbe671d13ccc08cf2c1c930f11bc52eb828cd9915c474d9f13ed25"
    sha256 cellar: :any_skip_relocation, ventura:       "fe6d8d942bdbe671d13ccc08cf2c1c930f11bc52eb828cd9915c474d9f13ed25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93d1af2e4679bf0d1d273706a970133c3534fe1c19dd065d5c3c61630fab3cde"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Weather", shell_output("#{bin}/stormy --city London")
    assert_match "Error: City must be set in the config file or via command line flags",
      shell_output("#{bin}/stormy 2>&1", 1)
  end
end
