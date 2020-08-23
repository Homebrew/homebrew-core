class RipgrepAll < Formula
  desc "Wrapper around ripgrep that adds multiple rich file types"
  homepage "https://github.com/phiresky/ripgrep-all"
  url "https://github.com/phiresky/ripgrep-all/archive/v0.9.6.tar.gz"
  sha256 "8cd7c5d13bd90ef0582168cd2bef73ca13ca6e0b1ecf24b9a5cd7cb886259023"
  license "AGPL-3.0"
  head "https://github.com/phiresky/ripgrep-all.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc8ee7c7869c23b82cb1997e4f7f5024193b74cc282c20c6bf50af43b55ddbb4" => :catalina
    sha256 "b1b26781f754760e790ff28c7a26079eb9df86b983c786cd745eabac0232c861" => :mojave
    sha256 "59001d904ce02e54e23842a7d04f9729d41f1e6fd8b81a71676812be5c6a20f5" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"file.txt").write("Hello World")
    system "zip", "archive.zip", "file.txt"

    output = shell_output("#{bin}/rga 'Hello World' #{testpath}")
    assert_match "Hello World", output
  end
end
