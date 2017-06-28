class Tokei < Formula
  desc "Program that allows you to count code, quickly."
  homepage "https://github.com/Aaronepower/tokei"
  url "https://github.com/Aaronepower/tokei/archive/v6.0.1.tar.gz"
  sha256 "f7f455995fa4f14019bb2f3a5203d7b551d8c453e9b7a533de6fa8d707c7fd74"

  bottle do
    cellar :any_skip_relocation
    sha256 "518e74274170384daa5642110a96e0b141ce03d498be6cac4e49a6e3e239a476" => :sierra
    sha256 "40b099abde5fb5d96ac89f79c714d73369ab65f86543702719918bf420df45b2" => :el_capitan
    sha256 "951ef73c9fab5a4ee45a99f6a41b954851d2507cc79f1dde0fd34c71e3d82469" => :yosemite
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/tokei"
  end

  test do
    (testpath/"lib.rs").write <<-EOS.undent
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
