class Webfs < Formula
  desc "HTTP server for purely static content"
  homepage "https://linux.bytesex.org/misc/webfs.html"
  url "https://www.kraxel.org/releases/webfs/webfs-1.21.tar.gz"
  sha256 "98c1cb93473df08e166e848e549f86402e94a2f727366925b1c54ab31064a62a"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "fc1329e4945435c639c82dbdacc43a9ae55521188aa6fd672d3446bd06822df5"
    sha256 cellar: :any, arm64_big_sur:  "1801afbf473ab499ddba5015432c87eed8f1316c921e181cf978dfae1c19a656"
    sha256 cellar: :any, monterey:       "73ad4360c6dc78e9b517e0088b9c4a60a83a7fadadced409f119f8d4634644d5"
    sha256 cellar: :any, big_sur:        "186343dd3f7bc14c248a9a52796f7afd63e430bdfaa71d570abb6142e7632b34"
    sha256 cellar: :any, catalina:       "192b771c2cf819773c9581bcdc83dacb9954c241ab41837ff844f736a53d5a1e"
    sha256 cellar: :any, mojave:         "f561f9dac64cd43165eefd01619d54042507a4f9a1d572c621e17229b63ec045"
    sha256 cellar: :any, high_sierra:    "52608c9f1bd5d7e7fceec24bff51ca67e0739b1c83ae2676c6ca161fdfaaa4d7"
    sha256 cellar: :any, sierra:         "9e678532e4546e4fabb9a96b9eb141769e00e330e15c9e5b453001141448c9fb"
    sha256               x86_64_linux:   "d84fb922078fc82f83e3052071edd57ca9add86938bbb00d7533121bfe2b9e38"
  end

  depends_on "httpd" => :build
  depends_on "openssl@1.1"

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
