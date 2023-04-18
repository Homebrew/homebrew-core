class Xidel < Formula
  desc "XPath/XQuery 3.0, JSONiq interpreter to extract data from HTML/XML/JSON"
  homepage "https://www.videlibri.de/xidel.html"
  url "https://github.com/benibela/xidel/releases/download/Xidel_0.9.8/xidel-0.9.8.src.tar.gz"
  sha256 "72b5b1a2fc44a0a61831e268c45bc6a6c28e3533b5445151bfbdeaf1562af39c"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^(?:Xidel[-_])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1c90b748fa5f9087602a8d8670c25b706c24c3be99c11758300604fbac9a3eea"
    sha256 cellar: :any,                 arm64_monterey: "73f305dc1833d8ebdea3236df50cb4de5f52bdbefa2a37d3b682cf1cd73c8dd5"
    sha256 cellar: :any,                 arm64_big_sur:  "b9758092865f250399c41f7eb2c22d8a85d3a6f201abd87cf8bcc2df9f5ce72e"
    sha256 cellar: :any,                 ventura:        "287aa987ef7a181f654506c15c24e58ed1e265118d8932f5bff259be79e76c70"
    sha256 cellar: :any,                 monterey:       "aecd66d3be7b4ab3ba13a57dab9f70988e9cf271e818ee0a06a2aebe0a62da4e"
    sha256 cellar: :any,                 big_sur:        "e0a2b032e2ad48fa616a29a3249a9c5fbee970832dac267f8430c67f6abc2895"
    sha256 cellar: :any,                 catalina:       "b3f68c54bd0e368870f81873cefe84d90249ec4d7cf2dfb68aae648d3fabb1ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a486375fd54f408102f37ffc3071fa806d318b56cdb03d6d0eeecc9f45f0b32"
  end

  head do
    url "https://github.com/benibela/xidel.git", branch: "master"
    resource("flre") { url "https://github.com/benibela/flre.git", branch: "master" }
    resource("internettools") { url "https://github.com/benibela/internettools.git", branch: "master" }
    resource("pasdblstrutils") { url "https://github.com/BeRo1985/pasdblstrutils.git", branch: "master" }
    resource("rcmdline") { url "https://github.com/benibela/rcmdline.git", branch: "master" }
    resource("synapse") { url "http://svn.code.sf.net/p/synalist/code/synapse/40" }
  end

  depends_on "fpc" => :build
  depends_on "openssl@3"

  def install
    resources.each do |r|
      r.stage buildpath/"import"/r.name
    end

    cd "programs/internet/xidel" unless build.head?
    inreplace "build.sh", "$fpc ", "$fpc -k-rpath -k#{sh_quote Formula["openssl@3"].opt_lib} "
    system "./build.sh"
    bin.install "xidel"
    man1.install "meta/xidel.1"
  end

  test do
    assert_equal "123\n", shell_output("#{bin}/xidel -e 123")
  end
end
