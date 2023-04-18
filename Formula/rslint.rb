class Rslint < Formula
  desc "Extremely fast JavaScript and TypeScript linter"
  homepage "https://rslint.org/"
  url "https://github.com/rslint/rslint/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "1f3388c0bedb5bfb4c83f49ab773de91652144cb08327038272ad715cb161a83"
  license "MIT"
  head "https://github.com/rslint/rslint.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6697bbdc7195bc43b2da2d32c7d1e53fbba9748c7f9f462dc08239e11cfd1c9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "add49e65c3cc1f8d0e544dd43212efa4508082b9c6fdaaa8bf54e2f6ee3880fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f935da848cd21f5f58b4cffc7625ec321c51a48a3c167fb956f230cea14684e9"
    sha256 cellar: :any_skip_relocation, ventura:        "3e7dfc37a22fe9075f6b8b45fdfac7e60b56a8baf356d46744ca0cb57b708bd3"
    sha256 cellar: :any_skip_relocation, monterey:       "6e5a4f7bb10c80874a93dec67e40d8cd9288782bb5d97259ec4aa5993bd82bc8"
    sha256 cellar: :any_skip_relocation, big_sur:        "67894ab1b9743c341e0032f8a62140494625d9196fe53040b7de5482cd2fae35"
    sha256 cellar: :any_skip_relocation, catalina:       "ee4645f20575b26bb225f0cc02f8d16fbf2bee3d567e61f9ac62205deaa2a2e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7afca2f2944a01e7f7605e4e8f63ca50a4881c5655aa61a50ca939b5c800790"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rslint_cli")
  end

  test do
    # https://rslint.org/rules/errors/no-empty.html#invalid-code-examples
    (testpath/"no-empty.js").write("{}")
    output = shell_output("#{bin}/rslint no-empty.js 2>&1", 1)
    assert_match "1 fail, 0 warn, 0 success", output
    assert_match "empty block statements are not allowed", output
  end
end
