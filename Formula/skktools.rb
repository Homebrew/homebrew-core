class Skktools < Formula
  desc "SKK dictionary maintenance tools"
  homepage "http://openlab.jp/skk/index-j.html"
  url "http://openlab.ring.gr.jp/skk/tools/skktools-1.3.4.tar.gz"
  sha256 "84cc5d3344362372e0dfe93a84790a193d93730178401a96248961ef161f2168"

  bottle do
    cellar :any
    sha256 "51e0f032378aa99d1c3d40cc20f4b0e44d917227202135ce4d3b660f86c4c407" => :high_sierra
    sha256 "0347744e8fb81108a0eb7a3bb99f6fd4debef7d34ac499e5312d458bde3b6134" => :sierra
    sha256 "1c7483904de37931199198fafd82bc3aee7ae3f9e89bf3c971aa13711579699f" => :el_capitan
    sha256 "eb770b46337d432b64c8dfd3e20d42212a32cdd00a8cffd92bb8e0ba32e46d6b" => :yosemite
    sha256 "541e53126d9e781515c1911d724e74c92bcefe790be8e7f187db04b35ba90a9d" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-skkdic-expr2"

    system "make", "CC=#{ENV.cc}"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"SKK-JISYO.TEST").write <<~EOS.strip.tap { |s| s.encode("euc-jis-2004") }
      わるs /悪/
      わるk /悪/
      わるi /悪/
    EOS

    (testpath/"SKK-JISYO.SHUFFLE").write <<~EOS.tap { |s| s.encode("euc-jis-2004") }
      わるs /悪/
      わるi /悪/
      わるk /悪/
    EOS

    expect_shuffle = <<~EOS.strip.tap { |s| s.encode("euc-jis-2004") }
      ;; okuri-ari entries.
      わるs /悪/
      わるk /悪/
      わるi /悪/
    EOS

    (testpath/"SKK-JISYO.SPLIT1").write <<~EOS.strip.tap { |s| s.encode("euc-jis-2004") }
      わるs /悪/
      わるk /悪/
    EOS

    (testpath/"SKK-JISYO.SPLIT2").write <<~EOS.strip.tap { |s| s.encode("euc-jis-2004") }
      わるk /悪/
      わるi /悪/
    EOS

    (testpath/"SKK-JISYO.SPLIT3").write <<~EOS.strip.tap { |s| s.encode("euc-jis-2004") }
      わるi /悪/
    EOS

    expect_expr = <<~EOS.strip.tap { |s| s.encode("euc-jis-2004") }
      ;; okuri-ari entries.
      わるs /悪/
      わるk /悪/
    EOS

    assert_equal "SKK-JISYO.TEST: 3 candidates", shell_output("#{bin}/skkdic-count SKK-JISYO.TEST").strip
    assert_equal expect_shuffle, shell_output("cat SKK-JISYO.SHUFFLE | #{bin}/skkdic-sort").strip
    assert_equal expect_expr, shell_output("#{bin}/skkdic-expr SKK-JISYO.SPLIT1 + SKK-JISYO.SPLIT2 - SKK-JISYO.SPLIT3 | #{bin}/skkdic-sort").strip
    assert_equal expect_expr, shell_output("#{bin}/skkdic-expr2 SKK-JISYO.SPLIT1 + SKK-JISYO.SPLIT2 - SKK-JISYO.SPLIT3 | #{bin}/skkdic-sort").strip
  end
end
