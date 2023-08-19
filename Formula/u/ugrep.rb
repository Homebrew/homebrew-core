class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v4.0.0.tar.gz"
  sha256 "a86e6a2ba5e833a0dcf46e115b3f103243f04e90ea6a361c65e15ceb4739803d"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "49f1c06b3102330c9f2b3f224c42ee87b2ec75d1527601e72193c10889ae24ea"
    sha256                               arm64_monterey: "1dbe2a6a526e9a966d533ed0890f49ee3312652af75cdb2c6a2b371b63a214c0"
    sha256                               arm64_big_sur:  "c8785ecdbb8878c700190a98fd273b533cbd94b6ba9bde00dc5ac6c896a5ebc4"
    sha256                               ventura:        "40afc444c8b260b37a22640616870fc91782cfcfbc9281138f6d200cb240ffbc"
    sha256                               monterey:       "46971db92c6c51988b0852c2f69d105aff48bcdecfa35d649dfd44e2b0194669"
    sha256                               big_sur:        "fbe68a2ee9e5fe801d224137dfce3ed97bee6e15f45964978bd61d2bd98ca271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22f0dc361178c6e7b1dfb17b1838e3801df78ab690fb85298f2dd69a6119c40d"
  end

  depends_on "pcre2"
  depends_on "xz"

  def install
    system "./configure", "--enable-color",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    assert_match "Hello World!", shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match "Hello World!", shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end
