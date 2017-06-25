class Tokei < Formula
  desc "Program that allows you to count code, quickly."
  homepage "https://github.com/Aaronepower/tokei"
  url "https://github.com/Aaronepower/tokei/archive/v6.0.1.tar.gz"
  sha256 "f7f455995fa4f14019bb2f3a5203d7b551d8c453e9b7a533de6fa8d707c7fd74"

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
