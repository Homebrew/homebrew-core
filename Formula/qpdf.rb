class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://qpdf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qpdf/qpdf/7.1.0/qpdf-7.1.0.tar.gz"
  sha256 "27054bfb83a4f4f70053c6d4c2de5e18ddf60c9a8edbce219ac1bdcf03f16a2e"

  bottle do
    cellar :any
    sha256 "80ef145668f4d20d4ed2c7ec435b5fb8391eeccb17dffc68bc365eea6631207f" => :high_sierra
    sha256 "882940253157307d4eba516a59c4d29a9ca4150ee11ef882346c4a54afc647da" => :sierra
    sha256 "64a7352582e9c2376e988b8610d80dd8c49f32a36604b38620114bee16133cd2" => :el_capitan
  end

  depends_on "jpeg"

  # Fix "error: no member named 'abs' in namespace 'std'"
  # Upstream PR from 14 Jan 2018 "Fix build with libc++"
  if MacOS.version <= :el_capitan
    patch do
      url "https://github.com/qpdf/qpdf/pull/172.patch?full_index=1"
      sha256 "7a85837cce1de8ba8e3abfcd7f5c7a35e70da93ea84ffdcf4ba34196dd60a0a4"
    end
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
