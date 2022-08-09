class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/refs/tags/v4.2.3.tar.gz"
  sha256 "1cd84fc2db606e83084a648152eb35103c3e30350825cb7553448d5ccde02a0d"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "35ec01dc4e5556036793494dbae83847be7ce02e578b04c20433197a63304819"
    sha256 cellar: :any,                 arm64_big_sur:  "59ac9a06b2a421e29f6ff2ac5fe5059fd953f8e8762b3f823464cd57db725a88"
    sha256 cellar: :any,                 monterey:       "773531a3d7ad2c360ec1d57f052b63c6b8547a0f4830591829ba05f6d4119a17"
    sha256 cellar: :any,                 big_sur:        "878154681e559545dae2eccfdfcd43616c109724e3e90ecb9bdedf938ee32ad1"
    sha256 cellar: :any,                 catalina:       "9dbf5097af9c14a455cc54634e9819da19b0e91dcf89f36c31b470e164c0556e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cf5ecd9956d77e340486a6a5e5fbbfbe2095502344c830372ecbbeeb20e0643"
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
