class Svlint < Formula
  desc "SystemVerilog linter"
  homepage "https://github.com/dalance/svlint"
  url "https://github.com/dalance/svlint/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "50a5d225351ef4971d766f2c1bb80af3ae36990c6b02ae3adb4c52a26f33d82d"
  license "MIT"
  head "https://github.com/dalance/svlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb9352e4a83d088a831817eee4a91f8669870b79fe3b2a78d60fc84302d46410"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "496ce91e9230ae3435a33778ece14a55e1dc5efff0da1ee724ef422fd9158487"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d667c3426d809d8332c59bef6be8a023ed338c10e2396ce94d0854a4e1205e22"
    sha256 cellar: :any_skip_relocation, ventura:        "b1cd7c50f2286aa6cfe7cc669072f69b77b4a9686c2ffefc3104963dda0047d5"
    sha256 cellar: :any_skip_relocation, monterey:       "f9c5165f3f4183a373d49346857cd7bb24ea45d9bbfbcb6be6151a232fde70fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "d31fc1ad67bdace077c7dd5862864253bd1679121ea4ae47f68d839f18fb85bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f27df9950b81166482b657d24b0f61fccb3104b0e4f080413cb5718de0894a6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.sv").write <<~EOS
      module M;
      endmodule
    EOS

    assert_match(/hint\s+:\s+Begin `module` name with lowerCamelCase./, shell_output("#{bin}/svlint test.sv", 1))
  end
end
