class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.4.3.tar.gz"
  sha256 "cfcbbe7b73a2a149e2b38ac6dd4bd4a6c1bdd6cf6f2a2bab49f6aeec3c705357"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "40e1d6f7e805a4627a0c9c8c2f743db1f86ff4d20ffe8ee8986d536d9d937728" => :catalina
    sha256 "ed59dfdf07cd7c9581b0d5f57be454a99b480a5bd916b7b67254a7a3197efa34" => :mojave
    sha256 "8a64fa405d29a1981c71994138fe00b2af2c344c15fd40ceabafa8cd996ff6f5" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "", shell_output("#{bin}/zoxide add /").strip
    assert_equal "/", shell_output("#{bin}/zoxide query").strip
  end
end
