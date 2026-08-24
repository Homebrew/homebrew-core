class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.49.0.tar.gz"
  sha256 "e585a0ae08c5fe9924061aeddf80f31214c146d26ab8094f2f241528f0b9473e"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ea49b3f1348eb1586150bad2000800288289c163bcb44b5b05dfb7f5c0e783b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70020f5c9d40062f94118d5f75f306d24bacecc62c64cee53669ba9730f74017"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c4403292085d0e21545ce48612611bc12195ed024362a50c9c6b6de6e9fc99a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4ba4d14ed30c8c54bd713b89fd863cd71f664f438c64724a2af41a4101a5cb0"
    sha256 cellar: :any,                 arm64_linux:   "2fec4fb85a61f2df18d365325c3f822c7de5a7735f40f4976deac2182c44f826"
    sha256 cellar: :any,                 x86_64_linux:  "57b9b6b9e63207fbb9c604bdab2d613a47aa5ad8ad21227992caf57106212b95"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
