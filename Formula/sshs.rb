class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://github.com/quantumsheep/sshs/archive/refs/tags/3.2.0.tar.gz"
  sha256 "8b3127178c7bff19c1ea1a5fd2c5758137863c7e7cfbc4900cdf3fa2f13007a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25ddb81546acf421a7314d16e113049b92247e6f5d9ef82d21b616c9c9b203dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d99b452bc112129f2cd1c0db08c54b89cc6c9d6efa12ad7d9a6eab77d514869"
    sha256 cellar: :any_skip_relocation, monterey:       "a94fbcb2090a8762122c6ebfed9f2b5fcbfdfbda259293ebeb5dfdd7919262f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4523020639af5422641feec22d3ff6c5b2027fc65d13c3ac1563e0d5e0a3e407"
    sha256 cellar: :any_skip_relocation, catalina:       "bcf3b701609f1a4eb851178d6e97ba0f18a8becd5e5537b046ffb79d32052bac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fde91b2d26c5147e1f2a97a2e26f7755419e9c1861ac68e591fc1662e49ba6f4"
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
