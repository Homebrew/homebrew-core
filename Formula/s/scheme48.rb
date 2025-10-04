class Scheme48 < Formula
  desc "Scheme byte-code interpreter"
  homepage "https://www.s48.org/"
  url "https://s48.org/1.9.3/scheme48-1.9.3.tgz"
  sha256 "6ef5a9f3fca14110b0f831b45801d11f9bdfb6799d976aa12e4f8809daf3904c"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/download\.html}i)
  end

  bottle do
    sha256 arm64_tahoe:   "dd9573e777e45950f016f490b3d37b0e5fd1257d3869dbde62a834ed11aed64a"
    sha256 arm64_sequoia: "e60e8422a87777d6f55e02a4a33e510d30d86b593b2f67dade9df8836d8cdac8"
    sha256 arm64_sonoma:  "a832d0cbc2b30a00712198511bc4ca9408e1523bf6ca93bf741780976a307047"
    sha256 arm64_ventura: "28ed573df3796dd14ca4380097dc117173104e860b44c414c065c047cefce4a1"
    sha256 sonoma:        "6fe0332fee2ab61f724c9494c00e2519721e4d0cf482c74b5d70d2a68caa044f"
    sha256 ventura:       "8ba60cefaf8708f4c554e1a1e1b619d6330e28f6aabdb2b7fd623e902cc9d853"
    sha256 arm64_linux:   "5f34e3f7fb0b982a57c1bc67fb6d5f18d608716833d1a0dc3a4617e8186fbf24"
    sha256 x86_64_linux:  "cb14bb2342582715834a1ea6dcf22b5c70292396b42b946182c0af189ad989ff"
  end

  conflicts_with "gambit-scheme", because: "both install `scheme-r5rs` binaries"

  # remove doc installation step
  patch :DATA

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", "--enable-gc=bibop", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"hello.scm").write <<~SCHEME
      (display "Hello, World!") (newline)
    SCHEME

    expected = <<~EOS
      Hello, World!\#{Unspecific}

      \#{Unspecific}

    EOS

    assert_equal expected, shell_output("#{bin}/scheme48 -a batch < hello.scm")
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index 5fce20d..1647047 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -468,7 +468,7 @@ doc/manual.ps: $(MANUAL_SRC)
 doc/html/manual.html: doc/manual.pdf
 	cd $(srcdir)/doc/src && tex2page manual && tex2page manual && tex2page manual

-doc: doc/manual.pdf doc/manual.ps doc/html/manual.html
+doc: # doc/manual.pdf doc/manual.ps doc/html/manual.html

 install: install-no-doc install-doc
