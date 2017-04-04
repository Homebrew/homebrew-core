class Tnef < Formula
  desc "Microsoft MS-TNEF attachment unpacker"
  homepage "https://github.com/verdammelt/tnef"
  url "https://github.com/verdammelt/tnef/archive/1.4.14.tar.gz"
  sha256 "26cd7c1a91fa080b4a05b9e81cdee4af9fbd5c6cda44db5f112a2ae9b3c37bd8"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f25392f0e35f58dd74cc3646629120b722e56375851cd3cf4aec43e1367cd56" => :sierra
    sha256 "4610ff74cdcb1421d112dbbaf98b397cbc4851362d03c5e132a1937b8a4c210e" => :el_capitan
    sha256 "6b9474530f6e1c02b710c6cb4ec346aaea65337a3fe2660e4da7e1da9dd3f479" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
