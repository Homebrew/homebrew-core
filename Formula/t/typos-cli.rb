class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.16.14.tar.gz"
  sha256 "15a9cc628253f78368e3c4b4d2d3f59c4191b3dd2c066d48c6403f61eb989d84"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23157f0fd10e0d5e7006eaa5c4e622670c828a106cc311c564338039e95bf9ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6324059b91fb3e735933dd4ff3e0362be13310c927565f7e4e583429e86a751d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d66f7f7933664979d4e66c3efab7a3508dc63fcc7b656d708a2f86308ae8130a"
    sha256 cellar: :any_skip_relocation, sonoma:         "303551d4fe17794f7bfe0b78b03f3c7d824e05024c8a72afdbc197d82f52d827"
    sha256 cellar: :any_skip_relocation, ventura:        "66877a4cc04eb8aebbea89c67fade29cfaf3894712fefeaf4de0781ac1440ea7"
    sha256 cellar: :any_skip_relocation, monterey:       "2a2a94493ebb07de6558cdea6d4e0ce35834b781093c4eb7a65fc2841f97e986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d82431f2a7026e9c5662967412dd4c4520617dd99c6cabdb5802d5e5ba8a4719"
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
