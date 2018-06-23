class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/Aaronepower/tokei"
  url "https://github.com/Aaronepower/tokei/archive/v7.0.3.tar.gz"
  sha256 "47848921f7f04fdd1ef515b2db25b931f97471f4b178c7914b3646251bcd8086"

  bottle do
    sha256 "2895c47b8bc84a128b379c3da43412bb7c10650375ab7d02da4be0b9ccb581cf" => :high_sierra
    sha256 "e288b99bbf45604558a6c91a90967a6cf2628987576236ceb784c0d20ed957de" => :sierra
    sha256 "b77f92594fa885a30a313673d5d69cb0733aca0e365e8128525bd9c66da24f55" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
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
