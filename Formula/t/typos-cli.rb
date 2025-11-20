class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.39.2.tar.gz"
  sha256 "2ac7b75fb8cd5091dfb3c07997a8f7d9abdc918260d0e2378cefdad7cf059923"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f10d39d01cbb085a5ab58ca0f279bfa313a7a061cfabddfc058f07b95d76cc8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f073cd666b16d1295961b36aa89767da772a034d8ac74282332d35116a4cae92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a34fff3da012336f0acc5f3b884d0175166f2117c9bd2aa4048074166620900"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1f83fa6b61dacebb7a0109e8fc624ec1e1576f1c58e70f22f8c977b011752e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44c6d64c7f4dacd92c09e370bd6b3718f8f12ea282d4028ef2b445ebcb119c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "802ad3e1bc2e079375639212f5bd2020d5310399e240e0b778df6c525307a535"
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
