class Skktools < Formula
  desc "SKK dictionary maintenance tools"
  homepage "https://github.com/skk-dev/skktools"
  url "https://github.com/skk-dev/skktools/archive/refs/tags/skktools-1_3_4.tar.gz"
  sha256 "84cc5d3344362372e0dfe93a84790a193d93730178401a96248961ef161f2168"
  license "GPL-2.0-or-later"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "20ab94e9dabb1954777337c8abb6d98e39fc9da6963e7ec852cf96b65bae7f5a"
    sha256 cellar: :any,                 arm64_sequoia:  "84de631d3930f335f030cfa8a3c8669d76c0052c26213b5321496087c4a156ec"
    sha256 cellar: :any,                 arm64_sonoma:   "e29e36abbb09213d335f3610286be258c8ee4f0f692cc30d66fa6553656c8e49"
    sha256 cellar: :any,                 arm64_ventura:  "00331db039291620e97f2dbd6b56062d00ffe4337a0fd6b041f1fb8952255be9"
    sha256 cellar: :any,                 arm64_monterey: "efda775981959fb7379c266e566532e39413278adc47cd63edad01d1e5b6479e"
    sha256 cellar: :any,                 arm64_big_sur:  "a00ce61f36ef97371d14fcd190fd130f5e3effda89a9e9dc42f416c366cfc17f"
    sha256 cellar: :any,                 sonoma:         "d48010adc51d34eb8dd0fd09e51006b70e026ae9939dcb613236b81ee89e79ab"
    sha256 cellar: :any,                 ventura:        "34347fbfb91b8272223fc83b58b8314a8fea0b66dfeab6d169b8f76a68f52ec0"
    sha256 cellar: :any,                 monterey:       "e1183e406c1029e930284dd352e92429e12dc695af9e1f01d80d35871328c4bc"
    sha256 cellar: :any,                 big_sur:        "8fbd977dbce7602bff5b095508963570d20555cb607e8526d0fa0f7941aedc42"
    sha256 cellar: :any,                 catalina:       "3a24b4de5dd2f12b857d47a9776a979c0dc41f47525e0cf0d4e639e73fcd0df3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0fb78300abadf0685a2be3a0e51eed5581127a51c3aa56d85da8ce6e4192d419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac8ed96d1342ecee708da56e9da672b9603b75c542bd835a83435d136e54100e"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gdbm"
  end

  def install
    args = ["--with-skkdic-expr2"]
    if OS.linux?
      args << "--with-gdbm"
      # Help find Homebrew's gdbm compatibility layer header
      inreplace %w[configure skkdic-expr.c], "gdbm/ndbm.h", "gdbm-ndbm.h"
    end
    system "./configure", *args, *std_configure_args
    system "make", "CC=#{ENV.cc}"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    test_dic = <<~EOS.strip.tap { |s| s.encode("euc-jis-2004") }
      わるs /悪/
      わるk /悪/
      わるi /悪/
    EOS
    (testpath/"SKK-JISYO.TEST").write test_dic

    test_shuffle = <<~EOS.tap { |s| s.encode("euc-jis-2004") }
      わるs /悪/
      わるi /悪/
      わるk /悪/
    EOS

    expect_shuffle = <<~EOS.tap { |s| s.encode("euc-jis-2004") }
      ;; okuri-ari entries.
      わるs /悪/
      わるk /悪/
      わるi /悪/
    EOS

    test_sp1 = <<~EOS.strip.tap { |s| s.encode("euc-jis-2004") }
      わるs /悪/
      わるk /悪/
    EOS
    (testpath/"test.sp1").write test_sp1

    test_sp2 = <<~EOS.strip.tap { |s| s.encode("euc-jis-2004") }
      わるk /悪/
      わるi /悪/
    EOS
    (testpath/"test.sp2").write test_sp2

    test_sp3 = <<~EOS.strip.tap { |s| s.encode("euc-jis-2004") }
      わるi /悪/
    EOS
    (testpath/"test.sp3").write test_sp3

    expect_expr = <<~EOS.tap { |s| s.encode("euc-jis-2004") }
      ;; okuri-ari entries.
      わるs /悪/
      わるk /悪/
    EOS

    expect_count = "SKK-JISYO.TEST: 3 candidates\n"
    actual_count = shell_output("#{bin}/skkdic-count SKK-JISYO.TEST")
    assert_equal expect_count, actual_count

    actual_shuffle = pipe_output("#{bin}/skkdic-sort", test_shuffle, 0)
    assert_equal expect_shuffle, actual_shuffle

    ["skkdic-expr", "skkdic-expr2"].each do |cmd|
      expr_cmd = "#{bin}/#{cmd} test.sp1 + test.sp2 - test.sp3"
      actual_expr = shell_output(expr_cmd)
      assert_equal expect_expr, pipe_output("#{bin}/skkdic-sort", actual_expr)
    end
  end
end
