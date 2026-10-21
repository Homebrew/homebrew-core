class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.51.1.tar.gz"
  sha256 "6dfe9ff8720e476ae93b4c4749270c4afb608694deb7bd6af4ecb09d222e6ddb"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c1437ea5cf6f1068fe109dd765c09a8d9cc804b6fb03ec32386fae28114d951c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aff2154201a88dba7a8a692435af0c6f68feee343474c270c71bd78afd82bae2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7f2b29fc631104c66d65523212732ba15c7dfabbf0bf668592c61527b4cf75c2"
    sha256 cellar: :any,                 arm64_linux:       "16cbfe90660d7f9a38b79122fe41d7113593b9cfff8b42e78963057f94e6a6ed"
    sha256 cellar: :any,                 x86_64_linux:      "b5913dee4cd6a58c642f9b4cd1cd712fb2f0aa67f10b8585233ccc28bf3246e7"
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
