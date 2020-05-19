class RipgrepAll < Formula
  desc "Wrapper around ripgrep that adds multiple rich file types"
  homepage "https://github.com/phiresky/ripgrep-all"
  url "https://github.com/phiresky/ripgrep-all/archive/v0.9.6.tar.gz"
  sha256 "8cd7c5d13bd90ef0582168cd2bef73ca13ca6e0b1ecf24b9a5cd7cb886259023"
  head "https://github.com/phiresky/ripgrep-all.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa8041bd45eba089f3cf80bcf83c75a02bdfb4d1f1fe195d86d0d444438d06a1" => :catalina
    sha256 "6c5f1e7b0f4cdf65750e65800e9030144180f6cf605292104fe67c775f65b82b" => :mojave
    sha256 "fb87b9ac0643c4530ce5528469b9502a564fa36f29cdc37f92d90b8030494ae2" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"file.txt").write("Hello World")
    system "zip", "archive.zip", "file.txt"

    output = shell_output("#{bin}/rga 'Hello World' #{testpath}")
    assert_match "Hello World", output
  end
end
