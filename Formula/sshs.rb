class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://github.com/quantumsheep/sshs/archive/refs/tags/3.1.0.tar.gz"
  sha256 "9a656d68b0514227a26f8a9a56537b56a5dddd079de67a892643fc0b9ac238b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa3f1ff7cee5358729f9e3b8b02d642fa1d1785481a4d6c52820c0a8c5d4cd48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf1471f11ca83079fd0be1c3fc95ecb6be462db9d1f3853d7e83c2c7b8a0a18f"
    sha256 cellar: :any_skip_relocation, monterey:       "a8da26ca02f720f827ad79040b5fc228dc1efc8e301105a36650fa428faa0fdf"
    sha256 cellar: :any_skip_relocation, big_sur:        "d28f4a1fe7fa5525602f86f13e599d8d3935fcccad209a0ebb8f2e1e613419a1"
    sha256 cellar: :any_skip_relocation, catalina:       "c0a428f15aaca16acc349652378a296925cf3a6a9e6003278bb6b5b76db1e559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cb62af018dff0a6e016caa36e9e272eedae70eaa8af6c2ba5d2d970a50aa8d7"
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
