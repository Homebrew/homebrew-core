class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://github.com/quantumsheep/sshs/archive/refs/tags/3.1.0.tar.gz"
  sha256 "9a656d68b0514227a26f8a9a56537b56a5dddd079de67a892643fc0b9ac238b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad2b231a0bc855fd57cccb3d7bfd05b9408c928ea81f43186bbca700dcc692a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c725b4ef6afee5c5197e988cfc17b18b0da123bfb6ddc6d2d447f03a7027c88e"
    sha256 cellar: :any_skip_relocation, monterey:       "0d2301b173186789f1ee42a1d2a60295461a2e1d5685c479f2d0d99fd8d4e6cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "83dd80157f7cef2b456bc58ece4856bea94e98a402a1fd355793cd6ed1e5925d"
    sha256 cellar: :any_skip_relocation, catalina:       "c9c471ed21dd6fb131e001e01bcd78ea4bf56a7c43ea39a05428130fb2df1cb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de5201f08b3948522ca05ca48d3ff40e70a13398cc0cb597eafdceca4b3f3e0b"
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
