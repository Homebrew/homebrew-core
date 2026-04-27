class Webfs < Formula
  desc "HTTP server for purely static content"
  homepage "https://linux.bytesex.org/misc/webfs.html"
  url "https://www.kraxel.org/releases/webfs/webfs-1.21.tar.gz"
  sha256 "98c1cb93473df08e166e848e549f86402e94a2f727366925b1c54ab31064a62a"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://www.kraxel.org/releases/webfs/"
    regex(/href=.*?webfs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256               arm64_tahoe:   "f9f5bab18e9e95db07eac63bc5912da746d6c65079ad9f369c02707eac6231ae"
    sha256               arm64_sequoia: "028458cad840c4a8702c7cef628be8ab33c46d7fa5cbdb9695990b0ac581b8ed"
    sha256               arm64_sonoma:  "eca50edb019731ee1e2757b9c43e8b5fd31f50338c1417a95cf96f347940276d"
    sha256 cellar: :any, sonoma:        "99831a510f30a665d3becf15679fcbc4cfd84c68ea5439b9c8d8b4f5302c658a"
    sha256               arm64_linux:   "37889030ee60e415cf3280fa50faabf88481ce0b2fc1eb6b090ba10cde3512e2"
    sha256               x86_64_linux:  "b92029c45a57cfd2461a4ebab150aef802b581d4a95971df5c122a2369c8359c"
  end

  depends_on "httpd" => :build
  depends_on "openssl@4"

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/webfs/patch-ls.c"
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
    pid = spawn bin/"webfsd", "-F", "-p", port.to_s
    sleep 5
    assert_match %r{webfs/1.21}, shell_output("curl localhost:#{port}")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
