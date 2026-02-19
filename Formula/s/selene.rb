class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/refs/tags/0.30.0.tar.gz"
  sha256 "2cb62ef165012f062208fbc906af0f390a60f2adcf0cba9f1d60c12feccf8d23"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dda5bb5c452a76baf591c09cb261ac305eb454092b38c0c4bf6c7e55a089137"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7a74a8cf951217daa515c208c4f40068ddebdae5aaf9951ec0d6436bc3fecf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac4825a8aeb601c537936187ce01cb0ee8b52d6058d0d8ea7a4bbc74711678f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4f7769cb4798c52295fe8a9832d8800d27d6f5f211f9da41294a3a6b31fb0ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c27f717bc98db91664c1125f224bf52b74b250c1218d83b931f3219940739829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e557d22a1a4bfbaaa14fd1c7fd9cd05e4154b9390a488e256cde521efea7106"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    cd "selene" do
      system "cargo", "install", "--bin", "selene", *std_cargo_args
    end
  end

  test do
    (testpath/"selene.toml").write("std = \"lua52\"")
    (testpath/"test.lua").write("print(1 / 0)")
    assert_match "warning[divide_by_zero]", shell_output("#{bin}/selene #{testpath}/test.lua", 1)
  end
end
