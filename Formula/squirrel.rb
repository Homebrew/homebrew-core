class Squirrel < Formula
  desc "High level, imperative, object-oriented programming language"
  homepage "http://www.squirrel-lang.org"
  url "https://downloads.sourceforge.net/project/squirrel/squirrel3/squirrel%203.1%20stable/squirrel_3_1_stable.tar.gz"
  version "3.1.0"
  sha256 "4845a7fb82e4740bde01b0854112e3bb92a0816ad959c5758236e73f4409d0cb"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "036b6172b0a11dde45cc6e28613a0db3a2aa1a7a44f220d1bd963a1903533a56" => :catalina
    sha256 "3080041c6bda4ffb009faea5924917586204cb004f9a01ac434ff86e0cdb1cd1" => :mojave
    sha256 "c57b21bbdcac5cbaf3d7319d64f08c150d16592138bdf1027e7032f579e10091" => :high_sierra
    sha256 "f4d3e6db56838a29cd7247f0933de64bb35a6dac581a9ade879205cbfc9d93f7" => :sierra
    sha256 "0b6dab6fc2a9a9a9d68d8310977041bd20a492cfe91a6daef07638b0cea55aad" => :el_capitan
  end

  # Upstream patch to fix compilation with Xcode 9
  # https://github.com/albertodemichelis/squirrel/commit/a3a78eec
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/dcaba40/squirrel/xcode9.patch"
    sha256 "7821b25b11c477341553c29dce5fb3fca2541e829276be2b2e3cd0c5b5a225d2"
  end

  def install
    system "make"
    prefix.install %w[bin include lib]
    doc.install Dir["doc/*.pdf"]
    doc.install %w[etc samples]
    # See: https://github.com/Homebrew/homebrew/pull/9977
    (lib+"pkgconfig/libsquirrel.pc").write pc_file
  end

  def pc_file
    <<~EOS
      prefix=#{opt_prefix}
      exec_prefix=${prefix}
      libdir=/${exec_prefix}/lib
      includedir=/${prefix}/include
      bindir=/${prefix}/bin
      ldflags=  -L/${prefix}/lib

      Name: libsquirrel
      Description: squirrel library
      Version: #{version}

      Requires:
      Libs: -L${libdir} -lsquirrel -lsqstdlib
      Cflags: -I${includedir}
    EOS
  end

  test do
    (testpath/"hello.nut").write <<~EOS
      print("hello");
    EOS
    assert_equal "hello", shell_output("#{bin}/sq #{testpath}/hello.nut").chomp
  end
end
