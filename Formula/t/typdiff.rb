class Typdiff < Formula
  desc "Diff tool that generates Typst documents highlighting differences between inputs"
  homepage "https://github.com/sou1118/typdiff"
  url "https://github.com/sou1118/typdiff/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "d7739a28bd42d674491ea4149fce6f8046a2ad7873f24efc3a809b621fb4508d"
  license "Apache-2.0"
  head "https://github.com/sou1118/typdiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7d83a91146d20c565a5e558be80515f57a2db6cd5018b8b4519fa5af797318d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7a3d45b7ac0dee958f8d5b9adbfa505b7c1eea1a2bf45661d83d85b4ab4ea4aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "43c4a3767d0cbc836bc440440a529c56820753a65ff9bfcedff4eea1944c187b"
    sha256 cellar: :any,                 arm64_linux:       "87ed3c5397fe1cdafa3a8d20ebdae1039d3296b91abbe61abdc1bc6eceef1f98"
    sha256 cellar: :any,                 x86_64_linux:      "cb0583e465bd2d8f44eb2995bea740507c2e14d97e8626dcb9f06b8077ca3524"
  end

  depends_on "rust" => :build

  allow_network_access! :build

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
