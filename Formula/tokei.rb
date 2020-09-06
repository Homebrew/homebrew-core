class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/v12.0.4a.tar.gz"
  version "12.0.4a"
  sha256 "e79338acc1c91748dad4b694a3ad8571153ecbea4a45f1010d2d8aad36c99768"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5864a5bcefee2ab0819cd07449839ab9189d04aa8ac3302c0bab85536b6c508" => :catalina
    sha256 "c40027988a8081bcd64f3fb5b4905d2efbba7d55231b0084d38578c268ea924a" => :mojave
    sha256 "3c2cb79394bdc792fb1880842077dabfc7b038f1126e29e66d4acba5349b0253" => :high_sierra
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
