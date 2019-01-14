class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/Aaronepower/tokei"
  url "https://github.com/Aaronepower/tokei/archive/v9.0.0.tar.gz"
  sha256 "f0d4f7008946bd77482871b8c48c0570f059d697f3eb59934505a40ce1922a5a"

  bottle do
    sha256 "137ef240f73c02dac90354234b438cd3f5c2f9c1cf5075a391c8cc288bdd840b" => :mojave
    sha256 "e06badc2722ed6c96e6d64030d12e08651f6ad4d882ac2c249d62d56ad22ed85" => :high_sierra
    sha256 "d7ad074a5d5eb1681f7980be1baa41e97127d3d538d482337c8ad8860657f9b9" => :sierra
    sha256 "de37219e09df50f8545e0cd7d478373a1c1b1a171a1706868980e1e330b456af" => :el_capitan
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
