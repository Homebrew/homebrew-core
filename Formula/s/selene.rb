class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/refs/tags/0.32.0.tar.gz"
  sha256 "cd208a4b3bae38decc9c7bb797c19615caaecf67606b3e593ca60b64d3416cd5"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "92ba4aa49b97955e87d0b1da3e2c344bfbf25212e33154c5e1b95977cda4f56b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4422e5f144497e79230ad7eb438278caf9b34851c44dbdca7ad601f0b4e5e226"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "658ee21747f33a782fe47d6be6a00d8858ce1481fea0074e3249a33732d16191"
    sha256 cellar: :any,                 arm64_linux:       "bdc685472eb4f1a4f16a5d77ec3879de4fb371f0ecfdda6a98c33788e9f2c82b"
    sha256 cellar: :any,                 x86_64_linux:      "38cd2f9fa32f638319d37b742d441666996d3b3579920221f522115b2ead658e"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "selene")
  end

  test do
    (testpath/"selene.toml").write("std = \"lua52\"")
    (testpath/"test.lua").write("print(1 / 0)")
    assert_match "warning[divide_by_zero]", shell_output("#{bin}/selene #{testpath}/test.lua", 1)
  end
end
