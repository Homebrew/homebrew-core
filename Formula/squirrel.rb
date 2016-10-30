class Squirrel < Formula
  desc "High level, imperative, object-oriented programming language"
  homepage "http://www.squirrel-lang.org"
  url "https://downloads.sourceforge.net/project/squirrel/squirrel3/squirrel%203.1%20stable/squirrel_3_1_stable.tar.gz"
  version "3.1.0"
  sha256 "4845a7fb82e4740bde01b0854112e3bb92a0816ad959c5758236e73f4409d0cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c3957604cc76bd0c2b3bc9db7d7e1cf73c3218dbab9bda47673d9ed92f5a7e3" => :sierra
    sha256 "a3ba69216ec68a32489febe2894de6fc52a681309e58df8625e3659fd578d28d" => :el_capitan
    sha256 "cf619e423c4e4e00a2bfdd2ae40c81238b66d9fcf07f95bbfe9536687dba875b" => :yosemite
    sha256 "b98f154a80d82eff0de14488ca60d5b96018d23df854d325f2abbd95c268ab02" => :mavericks
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
