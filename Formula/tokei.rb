class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/v12.1.0.tar.gz"
  sha256 "cd86db17fa7e1d94c9de905f8c3afca92b21c6448a2fc4359e270cb8daad0be2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "64f4a21669538cfd4ce4f7cce8f6caa21db7be05057efa4fb369f45157d71904" => :big_sur
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
