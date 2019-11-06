class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/v10.0.1.tar.gz"
  sha256 "4c58388c293d6c37b603fbbcf0bdefec244dc057accff623b44b77af65998b60"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "63878bee6112e9e38be6bdf9d1fe99860297184b0c3b62965b8fb51e4ec5bd53" => :catalina
    sha256 "18349aec9fdfa7b1222b8ab721e0fa43b76fccc29ea089129d7b7530dd479ba9" => :mojave
    sha256 "be81cee3ea74dc85dd458d1423fb91d63ffefced31923b7c6f14558317c7dcb9" => :high_sierra
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
