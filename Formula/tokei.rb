class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/v10.1.1.tar.gz"
  sha256 "ad203224b891ec75208d86b296d02f08770e0a4b6421827b1bac397fddd996ab"

  bottle do
    cellar :any_skip_relocation
    sha256 "cef6e9ca145b9ff94a20696cca63571010fda98d1867c3841e9d6ceb67f874d7" => :catalina
    sha256 "98371ce5532e291e2fecf46aeedd78daadc5fa8cee82971411b03b186b2d4e4a" => :mojave
    sha256 "99d066d7ad2b7aead1725cdeffe95eb97f95d5a7179c5790eed70defc5b09425" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", ".",
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
