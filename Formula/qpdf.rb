class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://qpdf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qpdf/qpdf/7.1.0/qpdf-7.1.0.tar.gz"
  sha256 "27054bfb83a4f4f70053c6d4c2de5e18ddf60c9a8edbce219ac1bdcf03f16a2e"

  bottle do
    cellar :any
    sha256 "c26c68ec2f09be96cda4b21ad23a6e7e6243121d8bf9ce4227545be39f8dc1e0" => :high_sierra
    sha256 "20441ef157d913182f5a75a2fa40dca76b5b110b01ca64597a6bed5fe74b3797" => :sierra
    sha256 "da38c81a17b35f8ee25cd6a10fe2a55d6a81cf0c158152c4e0d957e64a6ca04d" => :el_capitan
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
