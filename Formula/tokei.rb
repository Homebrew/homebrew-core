class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/Aaronepower/tokei"
  url "https://github.com/Aaronepower/tokei/archive/v6.1.3.tar.gz"
  sha256 "e6f4612963ee1449f712cadea1830d50bd3edb33d213ae38b1ffbac4fc44d2e3"

  bottle do
    sha256 "b341ce693d9d52758372edc08bd4cef06883761536b2fd83f78115ddc2d71e73" => :high_sierra
    sha256 "b5f2e5d8dcfc31e2a707f35b98e21b27577e928c4f72d4b1032b742c8140b401" => :sierra
    sha256 "12898dbcc5ffc252f24c4a1cd27894011cab97c47f3dd0f569a788431983a962" => :el_capitan
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
