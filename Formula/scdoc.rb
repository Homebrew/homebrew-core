class Scdoc < Formula
  desc "Tool designed to make the process of writing man pages more friendly"
  homepage "https://git.sr.ht/~sircmpwn/scdoc/"
  url "https://git.sr.ht/~sircmpwn/scdoc/snapshot/scdoc-1.4.1.tar.xz"
  sha256 "2bc96daae0ddfb858305e550eb00a544a7a6255edd0bd169dcb2fc0c035eca92"

  def install
    system "make", "LDFLAGS=", "all"
    bin.install "scdoc"
    man1.install "scdoc.1"
  end

  test do
    (testpath/"test.1.scd").write "thisisatest(1)\n\n# TEST\n\nthis is a test"
    system "#{bin}/scdoc < test.1.scd > test_output.1"
    assert_match "troff", shell_output("file test_output.1")
  end
end
