class Typdiff < Formula
  desc "Diff tool for Typst documents, similar to latexdiff for LaTeX"
  homepage "https://github.com/sou1118/typdiff"
  url "https://github.com/sou1118/typdiff/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "37170bd94017c75873690eb7760857610c0ad7cd521baa40c1fa4f2efb8e3175"
  license "Apache-2.0"
  head "https://github.com/sou1118/typdiff.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"old.typ").write("Hello World!\n")
    (testpath/"new.typ").write("Hello Typst!\n")
    system bin/"typdiff", "old.typ", "new.typ", "-o", "diff.typ"
    expected = <<~TYPST
      #let diff-added(body) = {
        set text(fill: rgb("#0000ff"))
        underline(body)
      }
      #let diff-deleted(body) = {
        set text(fill: rgb("#cc0000"))
        strike(body)
      }

      Hello #diff-deleted[World]#diff-added[Typst]!
    TYPST
    assert_equal expected, (testpath/"diff.typ").read
  end
end
