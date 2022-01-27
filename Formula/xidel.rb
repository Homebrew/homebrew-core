class Xidel < Formula
  desc "XPath/XQuery 3.0, JSONiq interpreter to extract data from HTML/XML/JSON"
  homepage "https://www.videlibri.de/xidel.html"
  url "https://github.com/benibela/xidel/releases/download/Xidel_0.9.8/xidel-0.9.8.src.tar.gz"
  sha256 "72b5b1a2fc44a0a61831e268c45bc6a6c28e3533b5445151bfbdeaf1562af39c"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^(?:Xidel[-_])?v?(\d+(?:\.\d+)+)$/i)
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
  depends_on "openssl@1.1"

  def install
    resources.each do |r|
      r.stage buildpath/"import"/r.name
    end

    cd "programs/internet/xidel" unless build.head?
    inreplace "build.sh", "$fpc ", "$fpc -k-rpath -k#{sh_quote Formula["openssl@1.1"].opt_lib} "
    system "./build.sh"
    bin.install "xidel"
    man1.install "meta/xidel.1"
  end

  test do
    assert_equal "123\n", shell_output("#{bin}/xidel -e 123")
  end
end
