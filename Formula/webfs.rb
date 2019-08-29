class Webfs < Formula
  desc "HTTP server for purely static content"
  homepage "http://linux.bytesex.org/misc/webfs.html"
  url "https://www.kraxel.org/releases/webfs/webfs-1.21.tar.gz"
  sha256 "98c1cb93473df08e166e848e549f86402e94a2f727366925b1c54ab31064a62a"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "f561f9dac64cd43165eefd01619d54042507a4f9a1d572c621e17229b63ec045" => :mojave
    sha256 "52608c9f1bd5d7e7fceec24bff51ca67e0739b1c83ae2676c6ca161fdfaaa4d7" => :high_sierra
    sha256 "9e678532e4546e4fabb9a96b9eb141769e00e330e15c9e5b453001141448c9fb" => :sierra
  end

  depends_on "openssl@1.1"

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/0518a6d1/webfs/patch-ls.c"
    sha256 "8ddb6cb1a15f0020bbb14ef54a8ae5c6748a109564fa461219901e7e34826170"
  end

  def install
    ENV["prefix"]=prefix
    system "make", "install", "mimefile=/etc/apache2/mime.types"
  end

  test do
    begin
      pid = fork { exec bin/"webfsd", "-F" }
      sleep 2
      assert_match %r{webfs\/1.21}, shell_output("curl localhost:8000")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
