class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/v9.1.1.tar.gz"
  sha256 "3b03edf37795312a1781a5d0aa86fffea6b0bd2de3da7ea18399b43e0a2b9229"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d24e33d832233a698327fa90c85a40c5be0084ad40370529b21baa1fde0efb3" => :mojave
    sha256 "9ad6763d0a35665983a59ee6873dc6ad9528ac55a90e2fa76751c49ae94c6fea" => :high_sierra
    sha256 "f56f5b300c7211f33f8632c878e337af1e85e423a11452d77f2cc44b25cd2705" => :sierra
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
