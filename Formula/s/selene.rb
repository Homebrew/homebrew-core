class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/refs/tags/0.31.0.tar.gz"
  sha256 "fa3ef29ce2b698714b7dac6b27ea7b19feaeccf016b0f5e6f328113702be6f04"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b73065a755a7eef418d9bbbb92dac08ea94a15a26ea3781a6489bb825fa377a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf8b1710c4e344f06bfea50d01b65e8bd07b0669ebeb130051897877364a2200"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15140ae5031819405b6caddfb4c321141b518ee1b60a0bfdf6254b99494b58ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "300cc89f5b528fa8d00454fdd1af6e24549ae3404a18279506e5e6ef9cd2a5d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b21f563d0d08bb8a0e3137566f6950572402de941f2cdb8d714ccbffcfb85de4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2568ba65ea7d979468569eb4c1da83b851ffe6ce22c22a064462be5f50404b2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "selene")
  end

  test do
    (testpath/"selene.toml").write("std = \"lua52\"")
    (testpath/"test.lua").write("print(1 / 0)")
    assert_match "warning[divide_by_zero]", shell_output("#{bin}/selene #{testpath}/test.lua", 1)
  end
end
