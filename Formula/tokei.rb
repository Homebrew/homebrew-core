class Tokei < Formula
  desc "Program that allows you to count code, quickly."
  homepage "https://github.com/Aaronepower/tokei"
  url "https://github.com/Aaronepower/tokei/archive/v6.1.2.tar.gz"
  sha256 "736bab89800c397acc3be961af12b80acc2ca71dc990792fff8935018a2f0698"

  bottle do
    sha256 "53ccc42b89ad19fad28ce1e043d5776f10ea32d8aad6d2810198612d2ff64c69" => :high_sierra
    sha256 "9ec430a5d41ffd3dea4001842c269193190adcc4968cb405754a65cb5bd5e955" => :sierra
    sha256 "9e3ec9a5dd0aaf6289871c9fcdcd37139349871e95931b6febe306e5388b932e" => :el_capitan
    sha256 "4747f489aaa9701939e7c25039b1137c2c53fcc19358e47c80c1717aa9ddde42" => :yosemite
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/tokei"
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
