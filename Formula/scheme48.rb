class Scheme48 < Formula
  desc "Scheme byte-code interpreter"
  homepage "https://www.s48.org/"
  url "https://s48.org/1.9.2/scheme48-1.9.2.tgz"
  sha256 "9c4921a90e95daee067cd2e9cc0ffe09e118f4da01c0c0198e577c4f47759df4"

  bottle do
    rebuild 1
    sha256 "50398406b73f7b6b5ce3c0f220694673e42b83bd63f11149a855498e4caf3c94" => :catalina
    sha256 "42cacccaf71990813012cdc819702fe24a93555998ac86d54e389ea40f6f2a87" => :mojave
    sha256 "590f06c7c31910eed48da06080959628982226e7b09e2aedd352fa6e4a6c2007" => :high_sierra
    sha256 "e9751df2e3cfd1a007d74d541ca494a439645e3006ad354ddf65b0abfb370864" => :sierra
    sha256 "af2ced8a13fdad5478f745c698b09071e71d84daca01c6e3e3c35961b06cbea4" => :el_capitan
    sha256 "475d12c64562fc2498fcd8d9a8bab76d4f290444e43fcf04c40c745a7f6c6923" => :yosemite
    sha256 "6ae24159bb6e2485465135ba60d60291be7681dfc9662e42f176bb9f9d4a6f00" => :mavericks
  end

  def install
    ENV.O0 if ENV.compiler == :clang
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--enable-gc=bibop"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"hello.scm").write <<~EOS
      (display "Hello, World!") (newline)
    EOS

    expected = <<~EOS
      Hello, World!\#{Unspecific}

      \#{Unspecific}

    EOS

    assert_equal expected, shell_output("#{bin}/scheme48 -a batch < hello.scm")
  end
end
