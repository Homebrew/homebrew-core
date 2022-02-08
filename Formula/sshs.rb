class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://github.com/quantumsheep/sshs/archive/refs/tags/1.3.1.tar.gz"
  sha256 "cc6cdfe6be6f3efea29c8acc5a60ea037a88e445bced1619e7002a851d9bbe88"
  license "MIT"

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
