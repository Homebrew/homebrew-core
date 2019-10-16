class RipgrepAll < Formula
  desc "Wrapper around ripgrep that adds multiple rich file types"
  homepage "https://github.com/phiresky/ripgrep-all"
  url "https://github.com/phiresky/ripgrep-all/archive/0.9.3.tar.gz"
  sha256 "06259e7c1734a9246c2d113bf5e914f4d418e53c201efc697bfc041a713fbef3"
  head "https://github.com/phiresky/ripgrep-all.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f1d3f4fabd54b15ceb30e3cd21da428077d088c4ec2eefbe784c50cf2968437" => :catalina
    sha256 "2e12ab8408a5477ade1faae0d4ff52feba1d62fa83c468d2013e3f4e3381f098" => :mojave
    sha256 "0647dbf099bec9e929e6dad6988a129116b784623c8da8caa1ebd7f284b62912" => :high_sierra
    sha256 "a705783f96e33d80f13fd67f53c4b11be3cce0ec1049cdadb53814941ac3035c" => :sierra
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"file.txt").write("Hello World")
    system "zip", "archive.zip", "file.txt"

    output = shell_output("#{bin}/rga 'Hello World' #{testpath}")
    assert_match "Hello World", output
  end
end
