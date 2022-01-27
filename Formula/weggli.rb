class Weggli < Formula
  desc "Fast and robust semantic search tool for C and C++ codebases"
  homepage "https://github.com/googleprojectzero/weggli"
  url "https://github.com/googleprojectzero/weggli/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "240ccf2914533d7c2114901792240b95a6b632432ddd91d1fe3bbb060e010322"
  license "Apache-2.0"
  head "https://github.com/googleprojectzero/weggli.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.c").write("void foo() {int bar=10+foo+bar;}")
    system "#{bin}/weggli", "{int $a = _+foo+$a;}", testpath/"test.c"
  end
end
