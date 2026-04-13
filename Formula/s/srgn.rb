class Srgn < Formula
  desc "Code surgeon for precise text and code transplantation"
  homepage "https://github.com/alexpovel/srgn"
  url "https://github.com/alexpovel/srgn/archive/refs/tags/srgn-v0.14.2.tar.gz"
  sha256 "2f39cbb6e86e3bfe0a01d7727b6d287a2c2399a9ceeda7ee2f47e7c00503b194"
  license "MIT"
  head "https://github.com/alexpovel/srgn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f5107accdec90fde7867d0221c94e00f7fca9fa241dcd2a81dcfcd7524a4e57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "193685484025a92debef55ac8d25d9d39733fe15ca3d83a50de43961dd9c220b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2ee1a107c6cc81d82a822bad3e25ae902fe5e162e84ad97d1e6297695609450"
    sha256 cellar: :any_skip_relocation, sonoma:        "d683f84a05fad0c898297cf994169d84597a1008198e6123467a43e6e65fceae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd17abab9141b6d7e6c616f8391794bce236dafda6c61dfbaf3d19ae831ed737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97ee55a9233b7d6fac1e1c5ad81d17d3d311ed86f9da3fc93967b1ae02c81e68"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"srgn", "--completions")
  end

  test do
    assert_match "H____", pipe_output("#{bin}/srgn '[a-z]' -- '_'", "Hello")

    test_string = "Hide ghp_th15 and ghp_th4t"
    assert_match "Hide * and *", pipe_output("#{bin}/srgn '(ghp_[[:alnum:]]+)' -- '*'", test_string)

    assert_match version.to_s, shell_output("#{bin}/srgn --version")
  end
end
