class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://github.com/quantumsheep/sshs/archive/refs/tags/1.5.0.tar.gz"
  sha256 "74edb1b69d83ed4de2d020e468ff7c4602a2857a821711f4454466417b069b7c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51d213592f12022974078a68b985bad17ca9698bbe355f94c8914370b68fbde3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6595c36cc71cc726795cfe2888b69d77da67aaf4c2746fcd13d6114b6986c7dc"
    sha256 cellar: :any_skip_relocation, monterey:       "9be8a5eeb06d7abca82ade00e9c3c24d4065fd0013ae887312cb54b11fa7da03"
    sha256 cellar: :any_skip_relocation, big_sur:        "cedba2975dc580306cba4909b09eaf5616b7ede6a764b1eb58062d3c068596d4"
    sha256 cellar: :any_skip_relocation, catalina:       "fb045a5bd8436dead0b6173d4c3f732e679a195c55232bf8d7dbba1d16dacdbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a459a74ff427c2ca7215a4a361f2a90504deacf1ee53e75a61943b332a665ff0"
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
