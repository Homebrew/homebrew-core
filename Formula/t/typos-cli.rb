class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "11c1ac4f9427cd572ce728c20814ebd8b8769ed909b7d1309d805d9a37b81084"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5818ae6863b77a8d76b454a6e5fc5ed217d09d24e75efd6cf571603ce024370b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0348f9b24c890ec0dd4c4baa74045244390069a31639b2d4031fdf205944e5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6822020575a3295db10e07084bbf7497bc5465191924403d8e9eac7a3add8a95"
    sha256 cellar: :any_skip_relocation, sonoma:        "200ed434852f914cf0bbc6a10e0a2a825195482518343172cfe0c790376bac19"
    sha256 cellar: :any_skip_relocation, ventura:       "87e9b1b9acee3714b46396eecdbb2b3e2c554a84a8fa6c5935fe5418ed918317"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7df8ddbaf34a1592d5cef190fa5c8c8417986fb80659b8404e1927844d691d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0d411a87e8cc18d355bc1fb0224fd4965cbbcd8a00d756933b2b672862864ea"
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
