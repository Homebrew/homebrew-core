class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/v12.1.1.tar.gz"
  sha256 "c8b94ddd3ffe3d712d8a63c9e90cf32bb4506c3ecc51c357cf399417bc7afcc8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "803e994bda8e499d7d8ed7b584319756cb917b6c566077abe92c583e7b7ffa04" => :big_sur
    sha256 "292ef25aba7ba4acc6760f353c09d131611050fde16f75ff60faff77a8e1f9e6" => :arm64_big_sur
    sha256 "6f8d9daba7bffc3bdca8801809df42250179de135e566885a23087c392f79a05" => :catalina
    sha256 "388e4436b3d20be506cfb62cb258479b7b77d2041c3762988cb3d88eb3606086" => :mojave
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
