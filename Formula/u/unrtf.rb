class Unrtf < Formula
  desc "RTF to other formats converter"
  homepage "https://www.gnu.org/software/unrtf/"
  url "https://ftpmirror.gnu.org/unrtf/unrtf-0.21.14.tar.gz"
  mirror "https://ftp.gnu.org/gnu/unrtf/unrtf-0.21.14.tar.gz"
  sha256 "b1f72e87f195bd50dbc974b800918df61c881706c11716b7bd0a1981e81b9587"
  license "GPL-3.0-or-later"
  head "https://hg.savannah.gnu.org/hgweb/unrtf/", using: :hg

  bottle do
    manifest_sha256 "2eed16e3c36c3d676f03ce2543458c293f31f5f4d9e57be535c9bb5f85a1a678"
    sha256 arm64_golden_gate: "492fbd3533b6e5cc92160c527a966015f4fd50e76b5ecd4261f524a9620dbdf6"
    sha256 arm64_tahoe:       "ba43df400660cf0b8dc74ab3bd3d45d6bbfd8868894ec9faa49f420bca24a024"
    sha256 arm64_sequoia:     "aa2a0add9ac9fe87755c6273765d7ecbe87381824fe20d080d821ffaf84a42f3"
    sha256 arm64_linux:       "986d21a03fd2a3be4df3819edf1d029aa6d683eafb636644a95d1b19a31f4b73"
    sha256 x86_64_linux:      "893398302af1ed96a003896c34e64bb29709530c7f4cb83fab213fed88869a73"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  # Fix macOS build errors, MacPorts PR ref, https://github.com/macports/macports-ports/pull/34986
  patch :p0 do
    on_macos do
      url "https://raw.githubusercontent.com/macports/macports-ports/658984b1c0c8032c32a27969853d7e958e9ae6e9/textproc/unrtf/files/patch-src_execdir.c.diff"
      sha256 "66a8f3509bdf69899c8a8a2b7dfae94a1916b3e8778e69443ab89548a4d3ab84"
      type :unofficial
      resolves "https://github.com/macports/macports-ports/pull/34986"
    end
  end

  deny_network_access!

  def install
    # C23 treats the upstream's unprototyped function pointers as zero-argument functions
    ENV["ac_cv_prog_cc_c23"] = "no"

    system "./bootstrap"
    args = %W[--prefix=#{prefix}]
    args << "LIBS=-liconv" if OS.mac?
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.rtf").write <<~'RTF'
      {\rtf1\ansi
      {\b hello} world
      }
    RTF
    expected = <<~HTML
      <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
      <html>
      <head>
      <meta http-equiv="content-type" content="text/html; charset=utf-8">
      <!-- Translation from RTF performed by UnRTF, version #{version} -->
      </head>
      <body><b>hello</b> world</body>
      </html>
    HTML
    assert_equal expected, shell_output("#{bin}/unrtf --html test.rtf")
  end
end
