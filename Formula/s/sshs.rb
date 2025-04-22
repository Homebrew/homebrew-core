class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://github.com/quantumsheep/sshs/archive/refs/tags/4.7.1.tar.gz"
  sha256 "6aabddb7ab72406ea68574d374595aae93a290018dde2d6241d6070070c3b1fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3f020c2f4309eaeee6e4969365c19a2fb45c66e87b921bab02420826dfcbec3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "550349c0620dd2b5f366b6fdce5e9308c7a94bf27582489a41bb22e4dd9a8244"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "acb492e67b1ef5ea37d080ad25d4f46bf35a26576578a140e6d2ab48cd117af3"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc739e901aec3b0ffe77613fd725f1bf341289d2f52627da3aa486da389e5deb"
    sha256 cellar: :any_skip_relocation, ventura:       "0f2f9b65a07c794c34a9e51583be6986c3b11664d978c9068d17084b332e1f2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbbbff1251ffa8088d5407312698e84bcadfb2fe7fb4510061d87ecc271eaf82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd2adda730fe12d19a93482e3b0c326936dd19b30a140e4aa29d3ae91f884812"
  end

  depends_on "rust" => :build

  # version patch, upstream pr ref, https://github.com/quantumsheep/sshs/pull/129
  patch do
    url "https://github.com/quantumsheep/sshs/commit/0ae3970b851e165a3a375d67f36cc49335ab50f3.patch?full_index=1"
    sha256 "6ded3bd0e7be515d2215a1da08ce193965d5a1ba5ea18a9f3c386f7d1400380f"
  end

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
