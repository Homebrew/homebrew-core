class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/refs/tags/v4.3.2.tar.gz"
  sha256 "a9587a813dc00ac8cdcfd6646d7f1c172f730cda8046ce849dfea7d3f6600b15"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "afc812231240dbad355eb2ddf0908c42630a41f5a38c7dd66edffdb130566de6"
    sha256 cellar: :any,                 arm64_monterey: "20b063c9084b7d87a7d6a3599159bf36c436ab18e85f6ac6fc9d7500c27fbc69"
    sha256 cellar: :any,                 arm64_big_sur:  "af43b7474ad37630b1051deeb83d8636d70a4b91a7dba9f93702002f479c30db"
    sha256 cellar: :any,                 ventura:        "b36ee04b15cb504d785fc8111c7805ff3805aeeeb46245d45be5fd6fb902f828"
    sha256 cellar: :any,                 monterey:       "31405d35b54fcaf73031d8e0f3eae6c88e3b5cdc41dd63943b794527537db9e4"
    sha256 cellar: :any,                 big_sur:        "4a0539150e26b4f84614d073adb193c67bc07fc999a360120482bbb02706e418"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dedb10b82437f7ab5f3bbfd73d14fc91a907df948e2b83461aeb6cda11cc3192"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "openssl@1.1"
  depends_on "protobuf-c"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-dotnet",
                          "--enable-cuckoo",
                          "--enable-magic",
                          "--enable-macho",
                          "--enable-dex",
                          "--with-crypto"
    system "make", "install"
  end

  test do
    rules = testpath/"commodore.yara"
    rules.write <<~EOS
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
