class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://github.com/quantumsheep/sshs/archive/refs/tags/4.7.2.tar.gz"
  sha256 "cb14fd50599bfb8de3f04b00cffb8eac9207f67e0ebbdd9380c311d141882f3b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2443c66fec7f7bfb754004d9a1770583c4ecd3788e267733a5f1d179aef82fc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c8691620baa73fad3c9d41b66bb555b49018b5a4026f78b8ebfc24b726b3a8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "438e736bbae8e0aeeac0f5b1e9833fe59601e8f94aad84093a2bf6ad7b4f3e8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dee907cd51f13ea86e5ff1905ab59f896f6896a06fe8ce5da239719638bc0061"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1fa7aba391712fb5797c09cb9f77e41662e722402754aad4acde490dc0d2429"
    sha256 cellar: :any_skip_relocation, ventura:       "7e8fa97a5a345fecb049ee6b602009dfdd7a85102e80ab31691422d82fe83d59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78da6be289b347c12f3c4d25788707e582fcb499be6a9e548d54add0c0254a75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4fdb3557d5009b2c521a74fc93c456b1bc3b2772da8002fb072cfbd445d14be"
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
