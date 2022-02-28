class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://github.com/quantumsheep/sshs/archive/refs/tags/2.1.2.tar.gz"
  sha256 "cb89afe8e05f25e2eda79aae2e46a121371baf89bce4e4fbe16ba48a7d5337e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f124405f2995020e1241fd6bca1ea8bac218f3a97b30f886f37bba74311d3fe7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ccbd1e70efd8dad941b1c63f4f55860c89400836c6d7c1a8814dc2d7cb90dc5"
    sha256 cellar: :any_skip_relocation, monterey:       "14e4f3ffc6f25638dfab32c921f051ab5107fc4984e2c45b3fc7f897bf3b8c37"
    sha256 cellar: :any_skip_relocation, big_sur:        "d54e845edbc14bac5bbf5941a2891c6319a99f836bc9c78b628b84a30c7c9ac3"
    sha256 cellar: :any_skip_relocation, catalina:       "e7693b44c1b83c2eb138e13e6dd318b376568d0021b0428c4440505d6548f40a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c165cc97d0a234a33dbacce59acaad0852e3aff1e4510a8c19c4232d9813df2d"
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
