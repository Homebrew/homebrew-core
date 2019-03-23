class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/Aaronepower/tokei"
  url "https://github.com/Aaronepower/tokei/archive/v9.1.0.tar.gz"
  sha256 "d7c18192a773158eb4c12534dbe16cd1de3023118149427441c2e1ef3f076a1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "6cedff1d132d6b496c803ccb6bf8381ff05363aaa30aa70bbc90ecb742496d4d" => :mojave
    sha256 "3b8f70b7be47c0c18c23a8b8a4e9c968d72e7c00be1dad633837e28b7a701994" => :high_sierra
    sha256 "440d1b527443015ef937933d7755a2242cfd88370250fc2948458b4f5fc64179" => :sierra
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
