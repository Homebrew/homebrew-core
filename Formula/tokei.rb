class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/v10.0.0.tar.gz"
  sha256 "e2dab2f028061c50ba8dd242cd7691488af8bf5e389ba8800f0843c1ff45df20"

  bottle do
    cellar :any_skip_relocation
    sha256 "b849389e410729b098184152d475cb94b3e0eaa08d2a01cb8bd1d7eccc7ab5a4" => :mojave
    sha256 "bc5e48bd772112589019170fabc46e65428adbe2ff7bdb846f25cec4b0937063" => :high_sierra
    sha256 "387fcc993d1e7f72dcc565b3dda4c334df451ace5a5290148397875a2f15d9c8" => :sierra
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
