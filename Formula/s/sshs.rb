class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://github.com/quantumsheep/sshs/archive/refs/tags/4.1.0.tar.gz"
  sha256 "b6b4ced5eca70e2b00b2269d2c53c1a512a5a74d24b9882c581d482b4dd6bf60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d4397732ddf9d29898ddbb00eb96f6239fc5d4c99cda4db2b149798846c1d43"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "463f6e7e6d4baa937f62622fe54b3b84b567552021fdd2d7dede01c6d11cf38c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edc36b5e587633bf04f4899eaa4eee07c7af95b1eb29880aff0e8140d7b9eeb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5b07cef4f6e02999a1a10e7c07fd200f51fa29fafff13cf529b4f8dcaa97445"
    sha256 cellar: :any_skip_relocation, ventura:        "bb8d7f5536213909b7ee8e62ca460e73f9cff182dc2ccfb5771e0cbdde387f7d"
    sha256 cellar: :any_skip_relocation, monterey:       "7b6ba3d05a1484b9f8e04fff83ec430c1d82f8ce96560c0ab24a51c8978868a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d012ca85404c613c54acfb648dee0658459a397a9f4afb3b303cd8f1b688caf2"
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
