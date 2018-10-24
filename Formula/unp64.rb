class Unp64 < Formula
  desc "Generic C64 prg unpacker,"
  homepage "http://iancoog.altervista.org/"
  url "http://iancoog.altervista.org/C/unp64_235_src.tar.bz2"
  version "2.35"
  sha256 "763713b1933374173f71465fb8e33b3124d84b5fd96e560dbb4edf076bdfeb65"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "8ea046591c46ac09c3b1d82e1143a19ed8aa0143526e982efaed503ba8391a78" => :mojave
    sha256 "3bb668767bea20f8002928722f6b05c1394965688bafa22c38cff72f3d160fea" => :high_sierra
    sha256 "0693a0f4eda10e575321a8e39a0dc5fdbc9efb796c77b51e6b144c2573fddec8" => :sierra
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
