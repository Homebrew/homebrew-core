class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/v12.0.3.tar.gz"
  sha256 "87c6f006a7fd065df22b6bf046a16cd9d9138877c87bed1736979374eebf493f"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1254d5f4c2d506babfaa4ad49601b29eb2c8e906b0c51f71114252713f3d5a5" => :catalina
    sha256 "7404f7ca27abf083adc771ff4ba6b42538c066689289691c15f5092067e4a618" => :mojave
    sha256 "862edf49c73233cfab98ac3675aed0e56812c092d0d914c4e5cd166579c4375f" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "all", *std_cargo_args
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
