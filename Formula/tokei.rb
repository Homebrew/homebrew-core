class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/Aaronepower/tokei"
  url "https://github.com/Aaronepower/tokei/archive/v9.0.0.tar.gz"
  sha256 "f0d4f7008946bd77482871b8c48c0570f059d697f3eb59934505a40ce1922a5a"

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
