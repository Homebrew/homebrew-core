class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/v12.1.2.tar.gz"
  sha256 "81ef14ab8eaa70a68249a299f26f26eba22f342fb8e22fca463b08080f436e50"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58c651b034293b8dc4d2dc00c7b2a13d8c6c3c093683ab5e1ebe08a1dc6cf6f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ca867ee898e06ea98d3f3012e753ecb6e292160353e187fa62619f86447ca7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7b1e487acc3cddaeb578dfab8ec1e8f81fe00834d60d81311b6ca56d2c29f1b"
    sha256 cellar: :any_skip_relocation, ventura:        "ecedf025a74087395440a35c5698d6e35e8831c9da184bee5ecab2d056cf1a0a"
    sha256 cellar: :any_skip_relocation, monterey:       "19c6b4270cf51286adf6e2ddfd2aa45bfa721d52bfe5c8c0792277311a930116"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb4878d9ef7023cba511a2c84635ebf1c428741772ebc5fd139f8a0c258574d4"
    sha256 cellar: :any_skip_relocation, catalina:       "65063af77fcd93f8e3340e48e7cd8db8c8effc00fc93dbf540c9ce60e764329f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db7e8862a35ed6f09f4c502c45d14e2891fdff54524b1daa728bcd8fdebef2b0"
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
