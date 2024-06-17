class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://github.com/quantumsheep/sshs/archive/refs/tags/4.3.0.tar.gz"
  sha256 "c7d2bd9f18fadbc35cc103fefbe68d600328a7d5cc711c6a200941dc15f897ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18c1f0849daeaeff8d5de5170003fa11aa3df6a6238722f3c0641f975ec1e325"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a00e456aabcd988aa50103005f5cc502cb1a1e079a9d414f7abeb99e20b98263"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5c2763f1c4f1c27e0c98030e8635e33e50abef3c6764ddc8c3ef68706788609"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1bfb10e70ed19299af38f0f57c1e7cb4af92f2827c90680b3fc21cbb82c3bf7"
    sha256 cellar: :any_skip_relocation, ventura:        "0d1c44aae4ecb04afe89b9245b9b72427c703b405eefe4c809c4aba56abdbb27"
    sha256 cellar: :any_skip_relocation, monterey:       "b3e47f1b6339699d8cb0c9617b419b3cf34a037fa589580f23292b6eb1dd384e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b232015ca14a05a04c1e5ce6436bd94cb41bf7383fdf5c7e3138ca317fbed00d"
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
