class Xidel < Formula
  desc "XPath/XQuery 3.0, JSONiq interpreter to extract data from HTML/XML/JSON"
  homepage "http://www.videlibri.de/xidel.html"
  url "https://github.com/benibela/xidel/releases/download/Xidel_0.9.8/xidel-0.9.8.src.tar.gz"
  sha256 "72b5b1a2fc44a0a61831e268c45bc6a6c28e3533b5445151bfbdeaf1562af39c"

  bottle do
    cellar :any_skip_relocation
    sha256 "fba738ca2b8b7c98770f15ac37fe824c440de248d271a4a3544ed7f7730f2a3a" => :mojave
    sha256 "20450073b91be33a6f863b5057952317d579c5835974c29bb6bee939d68dda5c" => :high_sierra
    sha256 "13c10cdbe9158109ab5f4099805b6003fbe430a960b9956957717482651378d4" => :sierra
    sha256 "62878dce5345f0b69db3102548e754be300063164f6dec7075d3402b73b3bc0b" => :el_capitan
  end

  depends_on "fpc"
  depends_on "openssl@1.1"

  def install
    cd "programs/internet/xidel" do
      system "./build.sh"
      bin.install "xidel"
      man1.install "meta/xidel.1"
    end
  end

  test do
    assert_equal "123\n", shell_output("#{bin}/xidel -e 123")
  end
end
