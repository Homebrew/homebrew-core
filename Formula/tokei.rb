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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e8ebff0ff4e422447970fce9d87917e61f01651d030124201d73853f7288f3e8"
    sha256 cellar: :any_skip_relocation, big_sur:       "70ec65406393fe4af7eb7aeb6ac261cfe7319b66b5559b1d65c56fcfdc77ee08"
    sha256 cellar: :any_skip_relocation, catalina:      "f65dfddfe85d0ca4a06707a65fac5746eb6a756d76021b5ec806ee4f1d0a3639"
    sha256 cellar: :any_skip_relocation, mojave:        "ea27c2cf381e93e5423d8e5ab3b19283fe99310fdc85323309b263747cc10b2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b7e8559aea7ffd8f9d05b698f29d025bbc4e14f7a0ce5ad04bf5123fbbcdce8"
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
