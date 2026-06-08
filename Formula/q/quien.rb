class Quien < Formula
  desc "Better WHOIS and domain intelligence toolkit"
  homepage "https://benword.com/quien-a-better-whois-and-domain-intelligence-toolkit"
  url "https://github.com/retlehs/quien/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "8361a2d292152896e93220ca5e85474ac72b5f44795f640f69b0b2a8dace26c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a588450373ecb684c9ae39d5d3307a7d56bd04f5be3d00be62ffb344e76ad7ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a588450373ecb684c9ae39d5d3307a7d56bd04f5be3d00be62ffb344e76ad7ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a588450373ecb684c9ae39d5d3307a7d56bd04f5be3d00be62ffb344e76ad7ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bf312f5e5276d247f914eef464415abf06bdf0e712bc7ba55dba02284484fbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9aef471b4f6097cbbb26735667c6499c629a31dfa338084ded3e168cca66ae4b"
    sha256 cellar: :any,                 x86_64_linux:  "bccb2c992d641f6d2ff618d1ac71129d0dd85968ce5713644166da23389cf2f1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "expect"
    require "pty"

    PTY.spawn(bin/"quien", "google.com") do |r, w, pid|
      r.expect "Org *Google LLC"
      w.write "s"
      r.expect "Issuer *Google Trust Services"
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
