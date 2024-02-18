class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "f6db34bd102703bf56cc2878ddfb249c3fb2e09c9194d3adb78c3ab79282c827"
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
    sha256 cellar: :any,                 arm64_sonoma:   "b13a73e826bce48da23cfc245bfff2b2a4d456cb76e4e583d702cb7353699ee2"
    sha256 cellar: :any,                 arm64_ventura:  "7bd5586da65739e9e5e07dfa181a6a243c2c2b7eb927b8e48fdb3c6ba65f11ca"
    sha256 cellar: :any,                 arm64_monterey: "a89c513a54088a968595147f28538a9921682898f134a5fee6b3bfa2ac0ee380"
    sha256 cellar: :any,                 sonoma:         "41d5063a832e0fcd85ec29110fc5dd3724535ea7d7944010c912d2436ab708a0"
    sha256 cellar: :any,                 ventura:        "4309b879b81ae2688194c83af41e1cfa3cb0b652d05b84979bee549236e1194c"
    sha256 cellar: :any,                 monterey:       "a986b7f22831fc2235f862815ad25b77d86c27219959480d8c3f8112de4cd860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75fd896e3e79de104037bc68baa81446a09260043b4bf9eeae9afbf6e40eb670"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "openssl@3"
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
          description = "Calls CBM KERNEL routine CHROUT"
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
