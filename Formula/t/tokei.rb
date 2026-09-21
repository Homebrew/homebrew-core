class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/refs/tags/v15.0.0.tar.gz"
  sha256 "966da7b9a81ac6cb777b9f159f4c02e5b83a8b8bd30ebf5991007839926b600c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/XAMPPRocky/tokei.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b352c426ae6eaedfbdcaec2f05fa8e57c4f6048b51e8ff0cfdef93659982e84"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b4a317ab7dc0bae1aece7cc63d2da2d9ec07630d70480d96c99cb6e2c04a7d95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fddabd437deb06c12eb75a6abc4937cef966dbba84c7cdb18feca6ba3aa138e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "d07a304e9460f3b46dac30bec8941cd25a691e4d162fae3ba3ab7bb1461b0c77"
    sha256 cellar: :any,                 arm64_linux:       "c1e12dabea4e5792211573280602bf7d23aba6c70f8d206327ef005acd973ad1"
    sha256 cellar: :any,                 x86_64_linux:      "2f342aa2930be4c59e0ba130ec56b6631e5c526793137271c276db484b4400ca"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "all")
  end

  test do
    (testpath/"lib.rs").write <<~RUST
      #[cfg(test)]
      mod tests {
          #[test]
          fn test() {
              println!("It works!");
          }
      }
    RUST
    system bin/"tokei", "lib.rs"
  end
end
