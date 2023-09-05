class Yazi < Formula
  desc "️Blazing fast terminal file manager written in Rust, based on async I/O"
  homepage "https://github.com/sxyazi/yazi"
  url "https://github.com/sxyazi/yazi/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "991f8621cf6f362d0c22cd598a434b6fb42fb7e9fde4c2f678297f9ac4959d36"
  license "MIT"
  head "https://github.com/sxyazi/yazi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "301b1c8fcb96c2b952be3362878dee3ceb534e2d04126027348211e04abee9eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7057f16963dcb9d11c2a24a99755460bf8e7098bffe16f5a96d58c075958a2c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "280d30ce1cc37b618540bd93f60211847e81b3e6274c4083120d95c8be50b25b"
    sha256 cellar: :any_skip_relocation, ventura:        "751a62e7215323685c5b66986da52d68556a6751b7d802cb81237fe9c6cd7b12"
    sha256 cellar: :any_skip_relocation, monterey:       "fdca4277149409056ab9def139e5d87ddf11c4a6ee167978f4fc61e1f2a7eeca"
    sha256 cellar: :any_skip_relocation, big_sur:        "07280d1a9341eed2646d316b340880c5965f948b318aaa872404584651e1cb35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "406dc52a16ce8b2de137c1ab866dcbdb3e55133db21299535941df76384550de"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "app")
  end

  test do
    require "pty"

    PTY.spawn(bin/"yazi") do |r, w, _pid|
      r.winsize = [80, 60]
      sleep 1
      w.write "quit"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    assert_equal "yazi #{version}", shell_output("#{bin}/yazi --version").strip
  end
end
