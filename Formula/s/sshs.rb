class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://github.com/quantumsheep/sshs/archive/refs/tags/4.1.1.tar.gz"
  sha256 "6869fbbc2a8eefb15ddcd9f6a930fed824e791df90351278c1125518422680a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cdd052b450f6cdde573e10c2c4f2c742cc83dc4843e7984bd1dce9b5b5276555"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7b5d30908f4202e94a847a12d77dc34e615eccdb00dc17f46c9fe5e77c55e27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3af8abfba4afcef181c50e0bed7955cdc68a3d02afc0a3ff01ed200c388cbe8"
    sha256 cellar: :any_skip_relocation, sonoma:         "d16daf2496d641dbd910b2819a02408e1408ed857d2be10cbab64ca1b5b1d4c3"
    sha256 cellar: :any_skip_relocation, ventura:        "0b6e4104bfaf9b0602664d1b10529c047f2ff55e5768dcd63a4fb64f24e8508b"
    sha256 cellar: :any_skip_relocation, monterey:       "0c2b7f28e9ce6b7b5500a399dd6a4270247ccd2a4b856db5cdb2d08534b9c8ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20a180daff1ae5381955003a7237a74f4a55124354a0fb53db555f4352eda0a3"
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
