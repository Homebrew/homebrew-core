class Unrtf < Formula
  desc "RTF to other formats converter"
  homepage "https://www.gnu.org/software/unrtf/"
  url "https://ftpmirror.gnu.org/unrtf/unrtf-0.21.13.tar.gz"
  mirror "https://ftp.gnu.org/gnu/unrtf/unrtf-0.21.13.tar.gz"
  sha256 "ff227d1a0adb84a9e1a51b5e5c3cecbda3d67c8a31dbd7e8593a040a438fb44c"
  license "GPL-3.0-or-later"
  head "https://hg.savannah.gnu.org/hgweb/unrtf/", using: :hg

  bottle do
    sha256 arm64_golden_gate: "a226864b8ca2d3a3fd005b4d15f67f42f2283d389a358d6a26519be44f67fa78"
    sha256 arm64_tahoe:       "cc979e852f9b1e2a2e64354acde5b7beb7b9210147f6887293302b6914834b7f"
    sha256 arm64_sequoia:     "b7fdfcdb1fa423dfff13a459a13b72a0d091eccf084138138575a9217bc22c5b"
    sha256 arm64_linux:       "56e196c69663296a493424ebbb430b19620cce002966f670e83e2b7c50a23d2e"
    sha256 x86_64_linux:      "6d15032cd02da2d37dfc830b5a1ded04f28490fcedd5d7e3e1ce625899fa2f54"
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
