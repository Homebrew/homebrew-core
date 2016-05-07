class Squirrel < Formula
  desc "High level, imperative, object-oriented programming language"
  homepage "http://www.squirrel-lang.org"
  url "https://downloads.sourceforge.net/project/squirrel/squirrel3/squirrel%203.1%20stable/squirrel_3_1_stable.tar.gz"
  version "3.1.0"
  sha256 "4845a7fb82e4740bde01b0854112e3bb92a0816ad959c5758236e73f4409d0cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d8142b159c9452fa98bcd2df2ecc307b8f7c1d8e698866bbfbe10bff225b891" => :el_capitan
    sha256 "25e35b7af1a94e1c7495751dbb7be829774411cd05727c6745c668c5188ef8f2" => :yosemite
    sha256 "f20d4132e3913e8f62f459375ede7765f416f6b9756c935253f06f65b8d4a172" => :mavericks
    sha256 "1d077d71f76fe8b9bbb5ddc70654e5de4fed72b12ecbf35764bdd6e4396cd31e" => :mountain_lion
  end

  def install
    system "make"
    prefix.install %w[bin include lib]
    doc.install Dir["doc/*.pdf"]
    doc.install %w[etc samples]
    # See: https://github.com/Homebrew/homebrew/pull/9977
    (lib+"pkgconfig/libsquirrel.pc").write pc_file
  end

  def pc_file; <<-EOS.undent
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
    (testpath/"hello.nut").write <<-EOS.undent
      print("hello");
    EOS
    assert_equal "hello", shell_output("#{bin}/sq #{testpath}/hello.nut").chomp
  end
end
