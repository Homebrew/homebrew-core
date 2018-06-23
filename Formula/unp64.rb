class Unp64 < Formula
  desc "Generic C64 prg unpacker,"
  homepage "http://iancoog.altervista.org/"
  url "http://iancoog.altervista.org/C/unp64_235.7z"
  version "2.35"
  sha256 "32f8606ecafed66180d434853a5e7992d82426d9e1fceb81bec467e1ea6c6921"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "5e7c0021a8b9fbc1370d2459481ed997a18fdb340a963baa18a3498b2109cf0f" => :high_sierra
    sha256 "c1900f99513a98e6cf6c0f21a3161851bdeebd8e506b458a183eef04cdc5f2e5" => :sierra
    sha256 "f4304f366634cfe3570b0766df93e75191b5839a27b82deaf440c928c9263497" => :el_capitan
  end

  def install
    cd Dir["unp64_*/src"].first do
      system "make", "unp64"
      bin.install "Release/unp64"
    end
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
