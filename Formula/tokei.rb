class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/v12.1.2.tar.gz"
  sha256 "81ef14ab8eaa70a68249a299f26f26eba22f342fb8e22fca463b08080f436e50"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "abf9d085c9b7f570febd69a431fcfa25b6bd2f3e6f70ee8a86ae34b5fbd2a114" => :big_sur
    sha256 "c9f0f41321eb5504b6a5867178a7686dda6f37eb47a040d828ce81096b2c515d" => :arm64_big_sur
    sha256 "89299611a6f336c378fe2be3eb67ff51fe0882eb18a066d6beda0b373e7f8a2a" => :catalina
    sha256 "f27651fba0d57a1c2977862114f5779bcf7c9a0d4199c4b742f8732145ebaff7" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "all", *std_cargo_args
  end

  test do
    (testpath/"lib.rs").write <<~EOS
      #[cfg(test)]
      mod tests {
          #[test]
          fn test() {
              println!("It works!");
          }
      }
    EOS
    system bin/"tokei", "lib.rs"
  end
end
