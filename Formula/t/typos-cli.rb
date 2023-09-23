class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.16.13.tar.gz"
  sha256 "99b4ded7f70ece732f0543636e092403a5a3498e6bb16e63b5e2ab598fc14f10"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "944b458f986abdee849b3b5e5dd8421d9e9673e5db4c2d8c5b6dac5a6a448dc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ee62132bf0bba043f887b499f569081b7add2f21b9381a61bcfe292c034ebd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fde4b20746bbf68fc269435901cb3bdd88dc4a51997bb2a0c0c16a258a008cda"
    sha256 cellar: :any_skip_relocation, ventura:        "059c4100dda0d81e3be372274419d679bcc827cd42997df6f92c17d4c41f5d86"
    sha256 cellar: :any_skip_relocation, monterey:       "4259c5ba7f1502aa8be35befdec60c83a2c692aeb922d83b8c5be00868009f0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f2eb8c6fa13e1eb88756ecc194f7315241478b9eff662d9302fa6d5693d82ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "446c056c005e297f9009d03e68ccc7bf57d7079194b70b50ae4b86a1d9a026f4"
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
