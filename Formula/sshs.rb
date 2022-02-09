class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://github.com/quantumsheep/sshs/archive/refs/tags/1.5.0.tar.gz"
  sha256 "74edb1b69d83ed4de2d020e468ff7c4602a2857a821711f4454466417b069b7c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "584f99a623ca4c9ba0edde67252b2aa96b90db9bdb5debbd7ed4ad117bf55a24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a2cfe6191b9ba89d0fded044cce7407b1c0af1c79eee94ab99eae362f0fc1e3"
    sha256 cellar: :any_skip_relocation, monterey:       "91a5c6d3f5ab8cf61c6f4163386f871c0e644182a096520c750e9ef3fe330a4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d012528d8b0b300a6f8f813dad9eca1d079cc94a9a95f1660194cc25ee50d6fa"
    sha256 cellar: :any_skip_relocation, catalina:       "d00faf7599582e85726e985096d5dd337374b81c5678be585e296fa7b6e956e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bef012dbb553c9ff0cd35497c013386376f20c9c4c35ff7818a5f1330156f96"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}", "OUTPUT=#{bin}/sshs"
  end

  test do
    assert_equal "sshs version #{version}", shell_output(bin/"sshs --version").strip

    # Homebrew testing environment doesn't have ~/.ssh/config by default
    assert_match "no such file or directory", shell_output(bin/"sshs 2>&1 || true").strip

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
