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

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "724da191fd997aadd63d61cc7f1fc90e9cf2bb9ef76e478b6a46e199f93f7a31"
    sha256 cellar: :any,                 arm64_big_sur:  "2bf1944684e71b179ea8d128e753b4d038a2028fdaa6fd818bdbc8cb6598bd39"
    sha256 cellar: :any,                 monterey:       "8386db4ca45746f4a6163a8e39f4720e5782e01b92af7b042e1c2bebaf5d2f21"
    sha256 cellar: :any,                 big_sur:        "e8ff32f1fb0cd5691c9e6afecc8c61f81d00aa5f2ea7a6cd96eed04090e5fe9d"
    sha256 cellar: :any,                 catalina:       "e074bd06a5093ce2f89ccd48568adfdf1a356dae797ea5034daf23b99e9b967d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89385fcaa91e5e59a4efdfafdd32e4748d858bad370efec8fb86757773a46a84"
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
