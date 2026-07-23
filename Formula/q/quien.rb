class Quien < Formula
  desc "Better WHOIS and domain intelligence toolkit"
  homepage "https://benword.com/quien-a-better-whois-and-domain-intelligence-toolkit"
  url "https://github.com/retlehs/quien/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "49eef2d196a1b9c1e46c037c8fa300f6ced71c952828761fb4810ad8151e14c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b28b9ec48f4cacf36536d308bcd2fc3fd7fbe53f90b192f1e1e87de407fe1a64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b28b9ec48f4cacf36536d308bcd2fc3fd7fbe53f90b192f1e1e87de407fe1a64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b28b9ec48f4cacf36536d308bcd2fc3fd7fbe53f90b192f1e1e87de407fe1a64"
    sha256 cellar: :any_skip_relocation, sonoma:        "7981d981302069d69296469a07f8e68bd5de60062f20c19786fa142d1d07c6c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c530c8d14bbaab32a9165ab691aa79b7be5bcd94262c10a77b3aee0097d215d"
    sha256 cellar: :any,                 x86_64_linux:  "3e78d26c5655431a493d535bf81351fefe38b028790b66d74a4497916247b6f9"
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
