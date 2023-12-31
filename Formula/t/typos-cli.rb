class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.16.26.tar.gz"
  sha256 "9a7b15faf2b17eff15677152666232ba0d4b53c4590c4b25fd369d0300001c99"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0b1e2a0444a288ded957a5809c6fc0447f3ff92969ab91a6a02455bbc4fe5af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1780f4bb41db2609f6f7c363e09cb032c9cd6809a1f3e897e701ada98235d21b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f61d805259bf9670c06653c892bb20afc8ecd4665a1dfc51fca4b275a4dedbf9"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d05f8690201d28dbb70ff99338ec242e5a580e40384cd32b8e74ea6b030be19"
    sha256 cellar: :any_skip_relocation, ventura:        "fbc974add68694a87be97f62648324f8e09e9a56cb169de488f9fb744fe8bd19"
    sha256 cellar: :any_skip_relocation, monterey:       "981ce9ba355bec1da3cfced15a1e0904039039102d17220d227b1b5619fe64d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f0419e8c454541112059ce68ee42dc4e331ded1aebbde2e2969ad0cb2d5456e"
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
