class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.37.2.tar.gz"
  sha256 "37962c93bbebd0726d1f5efd3b0058ef37d9176da3c3f69c7f1cdbffb5f690af"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "050497ae3dc9baa8cb480ac389130704fe02070e23a6bf7bd319ccc319478c91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d83d221f6ede7c3ca2f7b642a4f369fb47ea9d18e1bd0ba58434d55c91f0bbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6c7ff475a1fcc503198e9b881faedb5f09820b2125d279930fcd8c0bc63dd3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "33b5f24b9357062722ba9ee0d46c0b9a24b5382d6c8c18fe1ecdb1b4d767d4bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef925f2b45c9da4b216d2b22936e378e4e8917dce2b074d0679aa1404c1a7bfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a608761c8b5b5072f21cf493723095918fefd1e3773e2edb34e0ad71573216d2"
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
