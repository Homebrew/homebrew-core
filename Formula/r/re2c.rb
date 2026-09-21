class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org/"
  url "https://github.com/skvadrik/re2c/releases/download/4.6/re2c-4.6.tar.xz"
  sha256 "75bf2696445e831d0d44e0d9f2909eeffc18c09757f222b2fb025f7e59fe130b"
  license :public_domain

  bottle do
    sha256 arm64_golden_gate: "a0a9457636b8ded11407dc23378f3e9cbcfee8700dc943d968754b575d14cf28"
    sha256 arm64_tahoe:       "11e413256b8ce9f791e8709f60eef3953154825a687e7ddc00ff69735f9b474a"
    sha256 arm64_sequoia:     "2b97c4a1267cceb5bebdcf944a8dec891754d8eb9af6839b2632e7434ff2905c"
    sha256 arm64_sonoma:      "81b267aa538f0ad86ea8e0571acb272dc84256ea270c45c6252f359889b35013"
    sha256 arm64_linux:       "46de8e0da8f10748a4bf37c40d8f0cb330a7f9df1ab605b86c39f1de62e2f45d"
    sha256 x86_64_linux:      "e01d5ea8c54a70228807fefc24454a7cfc5db796b352ec796b2ab2a86d47f9fa"
  end

  uses_from_macos "python" => :build

  deny_network_access!

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      unsigned int stou (const char * s)
      {
      #   define YYCTYPE char
          const YYCTYPE * YYCURSOR = s;
          unsigned int result = 0;

          for (;;)
          {
              /*!re2c
                  re2c:yyfill:enable = 0;

                  "\x00" { return result; }
                  [0-9]  { result = result * 10 + c; continue; }
              */
          }
      }
    C
    system bin/"re2c", "-is", testpath/"test.c"
  end
end
