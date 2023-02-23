class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.13.12.tar.gz"
  sha256 "55d692f32d5e481ab19e406cfb8d6b789f3cb28d5083878bdafff9f0ec222d36"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28f459bee6b4b547eb412ea6fce36e3372accc1fa7d554fefe559c0e3253bc67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45cf1575732bcf2246fa8e0cc9fb412d121ffb52bec4019f0df53431e405598d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d170264fb5c99bc97e89428587d9c34f99c0220f191ae4cc10d6d5912d142e9b"
    sha256 cellar: :any_skip_relocation, ventura:        "5447acf4436a0a671b37b6dd33bbf58311e7cc237bcf790e67f363c87532aaa4"
    sha256 cellar: :any_skip_relocation, monterey:       "9bbda550b1eee362270f8527dfdd8040673c13282247a295142e5526f12326ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "4465ca11b7fe56a56ec704103df3bdf6f44c6174cfd2e183637c1fcc1420a3a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "161157c2d25b26fd425c12f2936720b51dffad27ef5fc8d9021e99658fc4999d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
