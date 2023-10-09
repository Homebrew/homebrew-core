class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://github.com/jdx/rtx/archive/refs/tags/v2023.10.1.tar.gz"
  sha256 "f722c106eb5b07a2f3b1b3ace9957943fccb84a1c5502240852ad3e915d55f0c"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7750f3fd33c46f7b2f481e4ac5633a82d8bceb059e79e0f3b07d30ff06759f7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a0a67a4d7eeb682370c18e7a57d462a9754bd989fc1a08d0767a99015300866"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dac2bf297389b69481a865102f635aadb70d094a938724577f6d851c24d7d1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "0487255b8f0f3487f583b76b1861897d5c6fe45b839c5a44a44301182f6b28e8"
    sha256 cellar: :any_skip_relocation, ventura:        "4e610ae58e9ea7d0a8ce72ea6c8b1b3fc9a6e0cfe1b7ec5de58ad10232f61989"
    sha256 cellar: :any_skip_relocation, monterey:       "06f00679e06f6ecb056f1eca96a9ddeb8e46d470d589a0dae955ee50efcb4bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ebb0897ab501e71ff8ba00f15f3e2c7bfaf570e7fec8ca8766dafa2c6ebd587"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
