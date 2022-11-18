class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://github.com/quantumsheep/sshs/archive/refs/tags/3.4.0.tar.gz"
  sha256 "f46f9185f97e35cf3b02286631df715027c3b0d374959c7e402a21bd30208f74"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88005c530ba21ad0e8870787ad1895f88a231ea4de1c6f4d20d1688ee8778f5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f83f76d1d83819e5708c518a9cdc852432263531f6bc6c6cec49d4837ffc74ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41715e062f739e5345013f1accc1f07adccdc26628f3bdd312350cb369af984e"
    sha256 cellar: :any_skip_relocation, ventura:        "a5f305f6c5a0f348a684fd049c455df58d2c2e77f5f012f9dde095b63d2f3d5e"
    sha256 cellar: :any_skip_relocation, monterey:       "8ef82182fed86751f6b60f4ab83cf101f99daa2a08c5041b008823ec38704bba"
    sha256 cellar: :any_skip_relocation, big_sur:        "c22e1abf1d3e2223cff9e4717a49f9317b0649dadc9efd9ce414a6bbd4641290"
    sha256 cellar: :any_skip_relocation, catalina:       "3571f62b144e746d7c63c71d9b63128393867039165c884c81e94b55843eb9c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0db2b2dec20f5fd9bdc5d9b18f5e6f7780352991dd9c4b025346b3ad1da3c6a2"
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
