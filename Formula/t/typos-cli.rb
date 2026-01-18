class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "9a82d8b8518eaaff52261b9d7a3eafb34772670f12d33fd03b3b2d40a64a1931"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6af5ca60df72295f519b840b402e9a7725dae1c9a7da81999c706543d742c379"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adf7ed0dad3449f9bfb00ca2370cdec2703cd482bdc420834fd7da602cb7493f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "625d8fcba6e1d72e32c0f1d8b34fb420f0ed738c53eb5203bf8f65a3272a41d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "374ae428b3a29422da289f46e559ecc48fe962c5e3d36a86aeb10ba99869851e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "479366234640e48048258bd6ecf1627b57e20b24b605d1462a5b0d5fcb8a88f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c1bc83838b324fc0f51ae0de2059d5e95ad7c2919ed1c1f0c1ecc69d493b2ec"
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
