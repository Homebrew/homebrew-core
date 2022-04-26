class Sshping < Formula
  desc "SSH based ping: measure character echo latency and bandwidth"
  homepage "https://github.com/spook/sshping"
  url "https://github.com/spook/sshping/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "589623e3fbe88dc1d423829e821f9d57f09aef0d9a2f04b7740b50909217863a"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "pod2man" => :build
  depends_on "libssh"

  def install
    rm "Makefile"
    system "cmake", *std_cmake_args
    system "make"
    system "make", "install"
    man8.install "doc/sshping.8"
  end

  test do
    assert_equal "Usage: sshping [options] [user@]addr[:port]",
      shell_output("#{bin}/sshping -h 2>&1 | head -n 1").strip
  end
end
