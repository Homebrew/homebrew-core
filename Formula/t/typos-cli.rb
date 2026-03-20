class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.44.0.tar.gz"
  sha256 "3ae8c6bbf21926ba0fc0b9acd3680c9827c50e5713242df63d112985d1a8bc3b"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b332c562e8b6ccb65a15e61707d8afe74d1329cfeff2cbc148f3320d626339d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03fd45712216997f4466d43d12b8c70375cb566d36dbd9c72140c476d77cee62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abf5476c9151ec2d2e084c07e6c61ad27648f89603459e3cb6745008347e193a"
    sha256 cellar: :any_skip_relocation, sonoma:        "856f4f8cde97dc92d21a2c3f43b8cec86047173d5886a5285c5de9702c741417"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1011959fe0ebc9d5603d5c4d0e60a61b030deae36b42ce0b87e53b63a3160a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f912d6bd2965183f19ebbbccd40c87bc25f2097586cbe6c6f697301bf869e89"
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
