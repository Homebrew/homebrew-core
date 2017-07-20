class Recoverjpeg < Formula
  desc "Tool to recover JPEG images from a file system image"
  homepage "https://www.rfc1149.net/devel/recoverjpeg.html"
  url "https://www.rfc1149.net/download/recoverjpeg/recoverjpeg-2.6.1.tar.gz"
  sha256 "32038b650acd8dc041d25c8d7078c987e8e0bad377fd1f9e7436614be810f103"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d6757c010195c678fcef62071ca1e098345c127d12ccdae6afdf4e7bd31c621" => :sierra
    sha256 "a500f738fb6c77bccb92a9cb54acc93a799ed7c96f331b88ff42fe2ce56004c7" => :el_capitan
    sha256 "06bb0dec687db1b511121129d50050580517dcfa8fec80587222844ae9d34646" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recoverjpeg -V")
  end
end
