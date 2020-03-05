class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/v10.1.2.tar.gz"
  sha256 "b532e1d0bfc79160ef89e5bfac4f2d3be631fbcc8b23a5b0211515e0c8d9ed2d"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "46efde8ba493826d8124f9288e8724cb92717d56dc635a401f401046459142be" => :catalina
    sha256 "033ce8d5bc0680b58aef055d4e9e7d462d272d73169b031ed0e41dd643113c09" => :mojave
    sha256 "a4463f16da1f11a46591045abc1be86a92db0095486136f4978eabb73a0ca523" => :high_sierra
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
