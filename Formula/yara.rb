class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  head "https://github.com/VirusTotal/yara.git"

  stable do
    url "https://github.com/VirusTotal/yara/archive/v3.4.0.tar.gz"
    sha256 "528571ff721364229f34f6d1ff0eedc3cd5a2a75bb94727dc6578c6efe3d618b"

    # fixes a variable redefinition error with clang (fixed in HEAD)
    patch do
      url "https://github.com/VirusTotal/yara/pull/261.diff"
      sha256 "6b5c135b577a71ca1c1a5f0a15e512f5157b13dfbd08710f9679fb4cd0b47dba"
    end
  end

  bottle do
    cellar :any
    revision 1
    sha256 "3794f28f0cec51b052105d03fa163724778d797ce00ca4ab912db8d9f0e6f0d0" => :el_capitan
    sha256 "6f12300a6296b73c9a3630c46e7f7a95b7b180fb13754ce1b9e32d14b1bd8c6c" => :yosemite
    sha256 "e7709cb0b1c47bbab784790c1ffb1929ec63dc05ee1c8864ba7b53ac60aad759" => :mavericks
  end

  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl"

  def install
    # Use of "inline" requires gnu89 semantics
    ENV.append "CFLAGS", "-std=gnu89" if ENV.compiler == :clang

    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    cd "yara-python" do
      system "python", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    rules = testpath/"commodore.yara"
    rules.write <<-EOS.undent
      rule chrout {
        meta:
          description = "Calls CBM KERNAL routine CHROUT"
        strings:
          $jsr_chrout = {20 D2 FF}
          $jmp_chrout = {4C D2 FF}
        condition:
          $jsr_chrout or $jmp_chrout
      }
    EOS

    program = testpath/"zero.prg"
    program.binwrite [0x00, 0xc0, 0xa9, 0x30, 0x4c, 0xd2, 0xff].pack("C*")

    assert_equal "chrout #{program}", shell_output("#{bin}/yara #{rules} #{program}").strip
  end
end
