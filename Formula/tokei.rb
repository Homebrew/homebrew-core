class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/v10.1.1.tar.gz"
  sha256 "ad203224b891ec75208d86b296d02f08770e0a4b6421827b1bac397fddd996ab"

  bottle do
    cellar :any_skip_relocation
    sha256 "72ed8f9825cff756c7429639d7edf6e5d488c7d5500e24f915c1f41d976b39bb" => :catalina
    sha256 "1f634d13729b8474d6c9358006b229971d8c3537ff4ce49a710101b728fdc054" => :mojave
    sha256 "88fb44377bcb212c5f9c7886f2779ffa3561ba521efbb68603477a0a97540304" => :high_sierra
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
