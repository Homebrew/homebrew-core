class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://github.com/quantumsheep/sshs/archive/refs/tags/4.6.1.tar.gz"
  sha256 "4a8d96ca607f3d20e641341b82e5d6118fcf5c8fbbab74f114dd9ad4eef6e1c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cbb5d4b3b81679d4b2cc0029f1a722a21b9ec32b33eca81cbdc451ed2f1f413"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b845cd9ad8c40b3c5abb7fafbae386484da548970b5c106e48c7514379eb2d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c388573ae4a0d16297b83c523a4b98c14a621a1047570d0d3678371afab08eb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "471b43a830adf962bac98836cfa0c5cea36a5850745b718ab899bf60d782f017"
    sha256 cellar: :any_skip_relocation, ventura:       "79e97b90b867548e0d93411a6201e78a5453bcb29d0e5274f075f252d28d18be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "359f65870724e6d085668f438c77b529bfa82fe04b302cd372a9ac1251811de2"
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
