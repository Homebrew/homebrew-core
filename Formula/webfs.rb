class Webfs < Formula
  desc "HTTP server for purely static content"
  homepage "https://linux.bytesex.org/misc/webfs.html"
  url "https://www.kraxel.org/releases/webfs/webfs-1.21.tar.gz"
  sha256 "98c1cb93473df08e166e848e549f86402e94a2f727366925b1c54ab31064a62a"
  revision 1

  bottle do
    cellar :any
    sha256 "867fbe1f213380efb695d89fe6d4cc3e5197d2d303b3d70da72a45814aacc669" => :mojave
    sha256 "bd713d90ce0e67a1cddf2b3274ddc7467e4b7b5c8ad8b80382e5c0c955c383c3" => :high_sierra
    sha256 "cbdc088ed6befb87ecda08bf4a23a9eff3bf3d61932d98aa1f8441bb1c0fd3b5" => :sierra
    sha256 "63755af9ac88711d4eb2e80016ef541ed40a1422f2fb2de3ded5c72b362cb39e" => :el_capitan
    sha256 "51985bfb7ca68d15261a296886cf0c6b317d870bc79aadf881429101b9a11e09" => :yosemite
    sha256 "79c670478aeb8f97d702a5112fde2dab07c92145ea836c12bfdf9a1acfca4232" => :mavericks
    sha256 "bced78e19fe50e4b1191fb41cd7aeecf50b1a5d946a13c89d211159553cbd637" => :mountain_lion
  end

  depends_on "openssl"

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
