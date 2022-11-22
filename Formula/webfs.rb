class Webfs < Formula
  desc "HTTP server for purely static content"
  homepage "https://linux.bytesex.org/misc/webfs.html"
  url "https://www.kraxel.org/releases/webfs/webfs-1.21.tar.gz"
  sha256 "98c1cb93473df08e166e848e549f86402e94a2f727366925b1c54ab31064a62a"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 2
    sha256 arm64_ventura:  "49156fc8ba3a476cf63f719f17e679ad66b96f1494ccf387ce7c0c6007150a56"
    sha256 arm64_monterey: "047b4b7404e97147da732a96019fa8e1bfb5f7e541ac9cc7178492ac12653b65"
    sha256 arm64_big_sur:  "56124768f91253664d4e30becdf5da71303e99cb26f3a0053c0707bde08c9889"
    sha256 ventura:        "65ebbb49cd4a93f5abb177d97e737e5cd1f5b08a33ffad4fa6ddfc647f79066b"
    sha256 monterey:       "d5e072f43509860bf1720573e0da3762e734aeb450dabe4e2e8ae4cd96dff185"
    sha256 big_sur:        "3d7288254445f01e83e1950144448608501a91897b793cc8c173657d8d17ac2d"
    sha256 catalina:       "0b85fe4886d6c3e04d1f96fdfb39bc70dea3a4e75aa5e943c2b8bf4dde3e17aa"
    sha256 x86_64_linux:   "3656131d83b5affd389f147cc542fa0c5717aa0cd7aec1b03e05603f3a4ac06e"
  end

  depends_on "httpd" => :build
  depends_on "openssl@3"

  patch :p0 do
    url "https://github.com/Homebrew/formula-patches/raw/0518a6d1ed821aebf0de4de78e39b57d6e60e296/webfs/patch-ls.c"
    sha256 "8ddb6cb1a15f0020bbb14ef54a8ae5c6748a109564fa461219901e7e34826170"
  end

  def install
    ENV["prefix"]=prefix
    args = ["mimefile=#{etc}/httpd/mime.types"]
    args << "SHELL=bash" unless OS.mac?
    system "make", "install", *args
  end

  test do
    port = free_port
    pid = fork { exec bin/"webfsd", "-F", "-p", port.to_s }
    sleep 5
    assert_match %r{webfs/1.21}, shell_output("curl localhost:#{port}")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
