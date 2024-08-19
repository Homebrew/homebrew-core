class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.23.6.tar.gz"
  sha256 "7dc35ab3c60d73f50811e64138147f6ffe934dafd768f30d14550125b9b153c4"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fdd8309829807584a7800c8ad3040420105ab7601e3daca035c88ff6d38f4cb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfe6b5db2bb55b6878e68f67c8cb4cdc4b99c7459e3bd333e54aeba4e14632fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0de9e82d2ea26dfa68a43ddbe82966ebd5dda377072ede4c8d637438cc1e47f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b0aa4bdb38200e8f79aec4f94093faec67dfcffe3c642dd41c77d0c22d1a88a"
    sha256 cellar: :any_skip_relocation, ventura:        "3ac982d94032c6e59a23885309058ce2de9eb5a60d9086daa674798ce6429e2f"
    sha256 cellar: :any_skip_relocation, monterey:       "76f3751d257f054216cf161d612174b99872b0580b24b2d5a253bb40c409b29f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98115bb6df205bcdb99f7dbdf042d2679c6f10bcf9f230cca90fa63a0dda6e29"
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
