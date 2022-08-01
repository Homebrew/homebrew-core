class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://github.com/quantumsheep/sshs/archive/refs/tags/3.3.0.tar.gz"
  sha256 "07992229eab5d97be4fac44a21d3ad3c89ef7c7d15c8814ed579a054334f5e5f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afeaae953e5defbe2cc44026633202ab86bd5b26e71a26edde6fbd00f3d85285"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "188aaaa4fcc0b606ffd75d5b05db5e430584394dc4e5e4ae18d2f4d0d1f6c244"
    sha256 cellar: :any_skip_relocation, monterey:       "0b8b87450edc7f5c5457ac1f4e2ba292e1bb3b78458e3e4133441b9d8d073f31"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f5b45adcca5f7ee50d95f291d8929c5f7aa9b60c81e9ac28051f4dc7d785f29"
    sha256 cellar: :any_skip_relocation, catalina:       "2a1f316d5d4708c02acdf3cf48ab41ffffb164dc0e984f03bc1f8aceec39cfc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a1321a22ffd0991d94a3e1aed3b070584d5f86f751c5376a4e82b38516ade6a"
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
