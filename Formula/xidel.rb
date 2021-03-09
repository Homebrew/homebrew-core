class Xidel < Formula
  desc "XPath/XQuery 3.0, JSONiq interpreter to extract data from HTML/XML/JSON"
  homepage "https://www.videlibri.de/xidel.html"
  url "https://github.com/benibela/xidel/releases/download/Xidel_0.9.8/xidel-0.9.8.src.tar.gz"
  sha256 "72b5b1a2fc44a0a61831e268c45bc6a6c28e3533b5445151bfbdeaf1562af39c"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave:      "885e1685c81a6abb9767a6e807894a98b5d296952e60fdad6341961ce4dc737e"
    sha256 cellar: :any_skip_relocation, high_sierra: "16eb3dc18004c0be8e384714ef543aa6dfe0b026e4ec0a7b6294dd499606bb12"
    sha256 cellar: :any_skip_relocation, sierra:      "623ba6f72816f4d9cb2055539a023f36a620add9c77a61193fcaea88a08cedf5"
  end

  disable! date: "2020-12-08", because: :unmaintained

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
