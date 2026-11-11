class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.52.2.tar.gz"
  sha256 "72d8b9ab9cc54512865f51d8ff65903532785b1c32d58fc4e179ddf89299c5be"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "16b00081e4ab4291c09c4dfbb929e235710500004afa35e6ed88a08d4f0d4fc1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "37c8e2a030fc3b41a9a4eba57f234b261c3ebf766126c67bdd73174199aec3b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fee5783777a18115489ed8a04396f235940c56990c3f0379488e1b9ef9860678"
    sha256 cellar: :any,                 arm64_linux:       "22027e5860e1a329b7cc390c7fb90c3733454bbf5eb2ade8d87b6c7bd9f2ad6c"
    sha256 cellar: :any,                 x86_64_linux:      "8afb430f73a5e9a66fd6e7c041e04ba640d04a11aea5e7f735a1eebaaa06f3ab"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
