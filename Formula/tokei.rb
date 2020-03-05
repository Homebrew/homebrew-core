class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/v10.1.2.tar.gz"
  sha256 "b532e1d0bfc79160ef89e5bfac4f2d3be631fbcc8b23a5b0211515e0c8d9ed2d"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "7059ea6c0dd738a1c9b44e5a0b057ab8b5215448ea3a777bebf5d57e2c42cec6" => :catalina
    sha256 "28df51a6e58990307b20b29a7fec6d36e04547f187cf2dc6e23f88f65967c473" => :mojave
    sha256 "7933ddd3161bc552a84931bfd5826c12960e047c676bb66b84f991c50ed1e215" => :high_sierra
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
