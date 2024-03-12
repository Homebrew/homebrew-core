class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://github.com/quantumsheep/sshs/archive/refs/tags/4.3.0.tar.gz"
  sha256 "c7d2bd9f18fadbc35cc103fefbe68d600328a7d5cc711c6a200941dc15f897ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2dcae47f811b4ca24d02491469d2834b3666978b248f707693093e9915d748d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ff852be1a7d76e65c6ead3a32d6e22aefb36b24f037e7822186ae1f2e14b3b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ee6410ed20189df320b2b43fda6612027a4400b0ff3cf66dd7162ba9ad40a64"
    sha256 cellar: :any_skip_relocation, sonoma:         "c16b3f3186cdb03a11d514ce81fd4c8149ab738c2aad22362dcf8680b5712983"
    sha256 cellar: :any_skip_relocation, ventura:        "d6d3af701ae485188001a556fa1f2df04dbe25153a395e457cc1f7a4c2b411a4"
    sha256 cellar: :any_skip_relocation, monterey:       "66466389f71b0787a01325abe93c6ac7e65a2bb6bfaf855a2472477d2853db4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "077ac2b7a88e5d2e824d203ba7de3ce2741fb2d805598e64622ddded18cda090"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "sshs #{version}", shell_output(bin/"sshs --version").strip

    (testpath/".ssh/config").write <<~EOS
      Host "Test"
        HostName example.com
        User root
        Port 22
    EOS

    require "pty"
    require "io/console"

    ENV["TERM"] = "xterm"

    PTY.spawn(bin/"sshs") do |r, w, _pid|
      r.winsize = [80, 40]
      sleep 1

      # Search for Test host
      w.write "Test"
      sleep 1

      # Quit
      w.write "\003"
      sleep 1

      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
