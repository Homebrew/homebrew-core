class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.36.3.tar.gz"
  sha256 "0ef0c0ac227b765ffc097da8888b65f155e9c0d8aa2bc1a4146bac942614c57d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "476d3f20ab64dfa414e611069806c94ec5bd4a3f8a55e9f68d1dfd1e387eb02d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f8afe9d09f74a48a38549cb6562901d7433d553d508e21886f156d99399821c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6106f02dd3747ae8a4d93bb96a488f482279b46a67ee13814b3969fa4984d9aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebfb301d0224c9a2cdb8f4cbabcdfb445b6c776714d485ab206d8daa50adf3c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4c6645253ac8b80c4e4b3f0938e5f8e94d32c872185d640b33f8a25ffd68930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72b4c49c6ea1bee8b9e3da0ed7cbd882728b5c7c61d2e38705e935bf572080d6"
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
