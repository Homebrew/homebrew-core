class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/refs/tags/v4.5.4.tar.gz"
  sha256 "586c9c21878f8b4d1b9423b89ac937f21f8057b03e3e9706f310549d453966fa"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara.git", branch: "master"

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "05e38fe530217dd618458e1e864b88c9e5376a1a620e25b52c45327a2ba5bee0"
    sha256 cellar: :any,                 arm64_sonoma:  "3eb68c783f2be47824839b7a24d2950945f5c6a6365e856543fa89a22e00ffbc"
    sha256 cellar: :any,                 arm64_ventura: "2d9d3ab818d55b5ac62615ed701072920575eb76b4705e627987298ed7c73a6a"
    sha256 cellar: :any,                 sonoma:        "f959e7e5f4ef46b3f184a22e48df80915d2174a9118c7824ee217039cab7eaef"
    sha256 cellar: :any,                 ventura:       "e60f16545e8349a9267d01b6d0a9218041108fc7f34477670106b9dc49160c28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d44b7e4a3f0bd5fca8274f440ee09b28b25e0b410f0f2d9a83ce02c2ecf5cb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9eb5a6a26ded5e51d4c574bcd60a0a800cdd16749c7789bd625526449ade9332"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "openssl@3"
  depends_on "protobuf-c"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules",
                          "--enable-dotnet",
                          "--enable-cuckoo",
                          "--enable-magic",
                          "--enable-macho",
                          "--enable-dex",
                          "--with-crypto",
                          *std_configure_args
    system "make", "install"
  end

  test do
    rules = testpath/"commodore.yara"
    rules.write <<~YARA
      rule chrout {
        meta:
          description = "Calls CBM KERNEL routine CHROUT"
        strings:
          $jsr_chrout = {20 D2 FF}
          $jmp_chrout = {4C D2 FF}
        condition:
          $jsr_chrout or $jmp_chrout
      }
    YARA

    program = testpath/"zero.prg"
    program.binwrite [0x00, 0xc0, 0xa9, 0x30, 0x4c, 0xd2, 0xff].pack("C*")

    assert_equal "chrout #{program}", shell_output("#{bin}/yara #{rules} #{program}").strip
  end
end
