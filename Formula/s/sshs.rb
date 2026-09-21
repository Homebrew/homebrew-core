class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://github.com/quantumsheep/sshs/archive/refs/tags/4.8.0.tar.gz"
  sha256 "d78c9a4b63fe7e1b6f4ea7de8910a28a6caa745f53a76feff59a3a580a9f6268"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "161a028555565b70788a31e082a965b5e507b001a568655622ebda55d34b4ed1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9c429cc8e63236a75a9d0d104f0f879e6c56e6b428aa80d6060cb052963c1152"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8171fefab314751a39c9842356e19c2343ca9087cfd1470407202180c25bf376"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b56acf1f6716d456066569b188f5ddbaeaa4f031c082cc2e60ddab855de4c95a"
    sha256 cellar: :any,                 arm64_linux:       "5f808f0334b206944aea0d118ff5c4db9507b9e0519f47c309e25c0f4476408d"
    sha256 cellar: :any,                 x86_64_linux:      "5c40d26dc113d2eb2afef2b515c02c1cfd9447f71c88b1737fcc6ff7ea2313af"
  end

  depends_on "rust" => :build
  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "sshs #{version}", shell_output("#{bin}/sshs --version").strip

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
