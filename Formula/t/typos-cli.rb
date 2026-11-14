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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c422cb13a1c26e9165c8384c05753ae13d750a2548e5df1412ca3acd0f373a1a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ee7f5d3f42def66886298d5e4f4a75c042a13500053d7b48d22aba38fe7b4f3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fb9c3481b64390f0ef3c90271d1f24a4785cf036956b73c7727a172a4e2ce316"
    sha256 cellar: :any,                 arm64_linux:       "ce57ce7327358856fdcd527d8a61abba2c292454a0a4ff26a7c684a218e24c58"
    sha256 cellar: :any,                 x86_64_linux:      "d3ac5e19433cdaaa357f260b7f80371cfde08717225a0cc65077d606ff68765c"
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
