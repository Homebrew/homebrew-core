class ThreeBody < Formula
  desc "三体编程语言 Three Body Language written in Rust"
  homepage "https://github.com/rustq/3body-lang"
  url "https://github.com/rustq/3body-lang/releases/download/0.3.0/3body-lang.tar.gz"
  sha256 "d381e6e21b26f461b767b52d189545803a20e34618da1cc235be12bd6790eee1"
  license "MIT"
  head "https://github.com/rustq/3body-lang.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "0.3.0", shell_output("#{bin}/3body -v").strip
  end
end
