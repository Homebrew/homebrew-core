class Unp64 < Formula
  desc "Generic C64 prg unpacker,"
  homepage "http://iancoog.altervista.org/"
  url "http://iancoog.altervista.org/C/unp64_236_src.tar.bz2"
  version "2.36"
  sha256 "55126d9cd6d3bb0d77aeba3c9bd5d9e16805b098c66de92b33f44814425c39e1"

  bottle do
    cellar :any_skip_relocation
    sha256 "2bcb692303d870dec60ae2e5c664ffca2ff8d6e46365700c0701ae0e7b19e23d" => :catalina
    sha256 "966cbf5ee30ed72e472df6fa40c80adc623a18c3ab9764e22185cb0b48da4e46" => :mojave
    sha256 "d84f3af986ace7e131687c719d399212ca7c8e5bb4fc5f7bc9d0910db4116132" => :high_sierra
    sha256 "60f32f5261a3a7cf7f0b7058a53163267a026fb03886875403c7ebae12eb0b34" => :sierra
  end

  def install
    cd "src"
    system "make", "unp64"
    bin.install "Release/unp64"
  end

  test do
    code = [0x00, 0xc0, 0x4c, 0xe2, 0xfc]
    File.open(testpath/"a.prg", "wb") do |output|
      output.write [code.join].pack("H*")
    end

    output = shell_output("#{bin}/unp64 -i a.prg 2>&1")
    assert_match "a.prg :  (Unknown)", output
  end
end
