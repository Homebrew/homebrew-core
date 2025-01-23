class Retry < Formula
  desc "Repeat a command until the command succeeds"
  homepage "https://github.com/minfrin/retry"
  url "https://github.com/minfrin/retry/releases/download/retry-1.0.5/retry-1.0.5.tar.bz2"
  sha256 "68e241d10f0e2d784a165634bb2eb12b7baf0a9fd9d27c4d54315382597d892e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ba9aabeed58659b5bb810b2cc266bcce7b9bdafa7767bd553b362e1add65e062"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fab2637e747061b35b938d0ec128394c62e5c6322913ca9e36a780ac7cf7baf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c9090a16f0e8aec18d85a0d997c64864332cccbeb036e91144f83e418d2e24b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43ed02da4008539afbb274d2801b3dc84b52e7a47a43fe441aed74c5ccce93c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad89f09c7a64b4718979c863e1d65b8b59ce1b6ecb95d68153e9fb1aabbab9f7"
    sha256 cellar: :any_skip_relocation, ventura:        "3bfe43d89d31ed19cd1a822f1e359a7820598ff579428dd438c8fd0574064aba"
    sha256 cellar: :any_skip_relocation, monterey:       "1bdb2938fe138151ee4325b2cc8fbaa62aa294af7353b276268133c5c59706b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08c9b562e484816df97ec9ffdb6849201f5e5958397269087f90dbc478b1e354"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    require "socket"
    port = free_port
    args = %W[--delay 1 --until 0,28 -- curl --max-time 1 telnet://localhost:#{port}]
    Open3.popen2e(bin/"retry", *args) do |_, stdout_and_stderr|
      sleep 3
      assert_match "curl returned 7", stdout_and_stderr.read_nonblock(1024)

      TCPServer.open(port) do |server|
        session = server.accept
        session.puts "Hello world!"
        session.close
      end

      assert_match "Hello world!", stdout_and_stderr.read
    end
  end
end
