class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/refs/tags/v13.0.0.tar.gz"
  sha256 "b426ab03b8eedf4fe3ea70ca8379a2355981b0e9ca1d0083a66e623858e7e481"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/XAMPPRocky/tokei.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfbfb50e668f1d8ee2b207916f0a269605d1febb47cedabc482a4d65ccd55f89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5462e338d658f4e8e365abdc46acc58fd4b90765156b38ef3f497f4741ee9487"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5b54d5c907252d7fb838f7f361c83d461270fb434470bca91d910af3be8e87b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecfc1927083905932da3ae86fded9b4036f07366344d017d20baeddd66a52654"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e31199c2d789898f4ab389fe07d5b1fe35f85924a3f8d7aaed4d34e67702d8f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc9ef7c69502526fd8045965852c0d788b86b34b5a70e01a942c9c32f208dc38"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "all", *std_cargo_args
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
