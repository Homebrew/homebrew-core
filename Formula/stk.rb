class Stk < Formula
  desc "Sound Synthesis Toolkit"
  homepage "https://ccrma.stanford.edu/software/stk/"
  url "https://ccrma.stanford.edu/software/stk/release/stk-4.6.0.tar.gz"
  sha256 "648fcb9a0a4243d2d93fc72b29955953f4e794edf04c31f2ed0ed720d05287d2"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4097ebf1065c8a253d41902fa54573748ca47f24cd8ec88f340db1f74ecd418" => :mojave
    sha256 "67c1c6c12bbf98d866bac55955d4715f94c05c63551bd0687646c6acd549de91" => :high_sierra
    sha256 "70c1c7e91fc3477055e6bc1a39dd5ef160c4e496887bb22b88d7fd149b03bfa6" => :sierra
    sha256 "e333e99c0fe8611be1fc7fb54d3e4e77f4cde210bb1c281031ed54b74187ef4d" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  fails_with :clang do
    build 421
    cause "due to configure file this application will not properly compile with clang"
  end

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make"

    lib.install "src/libstk.a"
    bin.install "bin/treesed"

    (include/"stk").install Dir["include/*"]
    doc.install Dir["doc/*"]
    pkgshare.install "src", "projects", "rawwaves"
  end

  def caveats; <<~EOS
    The header files have been put in a standard search path, it is possible to use an include statement in programs as follows:

      #include \"stk/FileLoop.h\"
      #include \"stk/FileWvOut.h\"

    src/ projects/ and rawwaves/ have all been copied to #{opt_pkgshare}
  EOS
  end

  test do
    assert_equal "xx No input files", shell_output("#{bin}/treesed", 1).chomp
  end
end
