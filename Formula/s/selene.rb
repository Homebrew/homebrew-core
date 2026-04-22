class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/refs/tags/0.30.1.tar.gz"
  sha256 "61c66d7e40d8d00fe8364a2696c7f87bcb976d838bd681fd802d427c7675a872"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbcf7c178fa11c1afbdd4e8b6774a63f59548f83271c410459e8ab880ad657d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8125a29586e52cd90876de09eab14a84971c9373d2b6c6e56c5d04cf3870cdf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e714599b1be78018752f5a906ad1a4f274bb7305a16ee18b4010f4f076bea247"
    sha256 cellar: :any_skip_relocation, sonoma:        "b80ff59bc0699f7a96ccef7827855fefb8a4753989c0486ae095bec7b82b8edc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89bcf20592930998bea9b22b5356d469999997747ddbbf9247421be333389113"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fd0ce6b395be9edd863fcfa1323417a4f22d8d853ea82edcb7974defe81cd40"
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
