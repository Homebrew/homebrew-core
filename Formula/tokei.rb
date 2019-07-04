class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/v10.0.1.tar.gz"
  sha256 "4c58388c293d6c37b603fbbcf0bdefec244dc057accff623b44b77af65998b60"

  bottle do
    cellar :any_skip_relocation
    sha256 "f103533c65977fe05d4f6c3c3bb4a743203f4ed2ee1db6b1e333f778afbb198d" => :mojave
    sha256 "6483b07776d509d91e57e619dcba915a334f016f144beb5018029ed394e5ad3b" => :high_sierra
    sha256 "9168e0097002c31e08b892625072dc86e1820a59d51a0c7a4c4f4aaaf1e2a4c0" => :sierra
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
