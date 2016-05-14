class Sam2p < Formula
  desc "Convert raster images to EPS, PDF, and other formats"
  homepage "https://code.google.com/p/sam2p/"
  url "https://sam2p.googlecode.com/files/sam2p-0.49.2.tar.gz"
  sha256 "0e75d94bed380f8d8bd629f7797a0ca533b5d0b40eba2dab339146dedc1f79bf"

  bottle do
    cellar :any
    sha256 "a7b4b13feef356880a78fcf32acbbd1f112fd6044fe6dbb0c6230c9a8af92e82" => :el_capitan
    sha256 "aa6af3133ebc8923ae4d532aa9389c8d4184f7f95b09ade962366e6d3f29188a" => :yosemite
    sha256 "cbdd3a795e0336c1bd4d0a397d9176be1749c6dcdf5fcc8ac842d6ccada0634c" => :mavericks
  end

  depends_on "gcc"

  fails_with :clang do
    cause "treating 'c' input as 'c++' when in C++ mode, this behavior is deprecated"
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-lzw",
                          "--enable-gif"
    system "make"

    bin.install "sam2p"
    bin.install "sam2p_pdf_scale.pl"
  end

  test do
    system bin/"sam2p", test_fixtures("test.gif"), "EPS:test.eps"
    assert File.exist?("test.eps")
  end
end
