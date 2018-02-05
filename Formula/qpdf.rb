class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://qpdf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qpdf/qpdf/7.1.1/qpdf-7.1.1.tar.gz"
  sha256 "8a0dbfa000a5c257abbc03721c7be277920fe0fcff08202b61c9c2464eedf2fa"

  bottle do
    cellar :any
    sha256 "80ef145668f4d20d4ed2c7ec435b5fb8391eeccb17dffc68bc365eea6631207f" => :high_sierra
    sha256 "882940253157307d4eba516a59c4d29a9ca4150ee11ef882346c4a54afc647da" => :sierra
    sha256 "64a7352582e9c2376e988b8610d80dd8c49f32a36604b38620114bee16133cd2" => :el_capitan
  end

  depends_on "jpeg"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
