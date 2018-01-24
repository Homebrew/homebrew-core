class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/Aaronepower/tokei"
  url "https://github.com/Aaronepower/tokei/archive/v7.0.1.tar.gz"
  sha256 "71c9be9ad04bc66501f5f54e74b5cf5e56fc1392ceead5525b743006145ac3a9"

  bottle do
    sha256 "9ddc97082885c00d12d61da6bf6bac1889bfcf4d66371f289d47b8854ed618ad" => :high_sierra
    sha256 "5b63b0f5fe0e2dd347a6104e3af36aae7b2de70b3e65967b9c2a0ba77e536e53" => :sierra
    sha256 "3e497eeb0db677cd8ab57433701398438deb7a73b4c083f7c73c6a13238ac95b" => :el_capitan
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
