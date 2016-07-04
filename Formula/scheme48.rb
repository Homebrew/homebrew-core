class Scheme48 < Formula
  desc "Scheme byte-code interpreter"
  homepage "http://www.s48.org/"
  url "http://s48.org/1.9.2/scheme48-1.9.2.tgz"
  sha256 "9c4921a90e95daee067cd2e9cc0ffe09e118f4da01c0c0198e577c4f47759df4"

  bottle do
    revision 1
    sha256 "af2ced8a13fdad5478f745c698b09071e71d84daca01c6e3e3c35961b06cbea4" => :el_capitan
    sha256 "475d12c64562fc2498fcd8d9a8bab76d4f290444e43fcf04c40c745a7f6c6923" => :yosemite
    sha256 "6ae24159bb6e2485465135ba60d60291be7681dfc9662e42f176bb9f9d4a6f00" => :mavericks
  end

  conflicts_with "scsh", :because => "both install include/scheme48.h"

  def install
    ENV.O0 if ENV.compiler == :clang
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--enable-gc=bibop"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"hello.scm").write <<-EOS.undent
      (display "Hello, World!") (newline)
    EOS

    expected = <<-EOS.undent
      Hello, World!\#{Unspecific}

      \#{Unspecific}

    EOS

    assert_equal expected, shell_output("#{bin}/scheme48 -a batch < hello.scm")
  end
end
