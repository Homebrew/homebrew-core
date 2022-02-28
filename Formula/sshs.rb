class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://github.com/quantumsheep/sshs/archive/refs/tags/2.1.2.tar.gz"
  sha256 "cb89afe8e05f25e2eda79aae2e46a121371baf89bce4e4fbe16ba48a7d5337e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "694c9027f9b63c89b2e214c6152bbdcce8535ebf6e9cdd2bbcc9fe5c8ab3c94f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b39cb1bbbe606d1187aaea3d55dc464bef71544b5b766fbc17898404fd4d2b1f"
    sha256 cellar: :any_skip_relocation, monterey:       "2dd165e209c7dec45f6e9beb29cd5a4f19d8592666811f0f193639b3abca8de9"
    sha256 cellar: :any_skip_relocation, big_sur:        "367db5e651c77dba9ffa500d0d6ff6e5e4eafa79e324ce410f104c27b44f95a2"
    sha256 cellar: :any_skip_relocation, catalina:       "a9fdee503915b4373ed0b4b6a68626238d22f6031eb4125d81cdb54e390ef65c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8d902bfb6a452cec887d2f1ed31f8219f4027efed52a01cb155870180a1dbee"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}", "OUTPUT=#{bin}/sshs"
  end

  test do
    assert_equal "sshs version #{version}", shell_output(bin/"sshs --version").strip

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
