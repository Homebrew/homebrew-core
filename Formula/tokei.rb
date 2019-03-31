class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/Aaronepower/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/v9.1.1.tar.gz"
  sha256 "3b03edf37795312a1781a5d0aa86fffea6b0bd2de3da7ea18399b43e0a2b9229"

  bottle do
    cellar :any_skip_relocation
    sha256 "11c293fada9e4eb940e448773e69a702f3b2cc179d2659c759791dfc5e38e801" => :mojave
    sha256 "bc94436bb0e6257fc95e063a8822b25697d42436102b28e83d6424cd5ec04711" => :high_sierra
    sha256 "c3f2640ed950476c0fb09b76274e5347c10ba6361fd09864fef014cb636f9513" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", ".",
                               "--features", "all"
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
