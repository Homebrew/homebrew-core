class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.27.8.tar.gz"
  sha256 "c45f62bc8bd6208290fea3e5edb01e1011d1440ed94a49091db26edcab36ac6f"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "023f63d711293d9e9e511e80624b19e4d96f0d38b3411ee1090bb073423ee5ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bb22c16553f27418d94efbb4701442743fac7ba1a9eb3bcdefb00f92a29c4c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a98af603d321e8c40baa9e3622f7c928bd339b8cebc929ca31a818f9e3f473f5"
    sha256 cellar: :any_skip_relocation, ventura:        "ce4601a746d1d42358ec8f3d1efb9cf8b32124589fdcfd10b972c7fd02f47af6"
    sha256 cellar: :any_skip_relocation, monterey:       "c9ccb035602b960d5de39feef7d5efc93820c75807d7439b3092f74bd34f3d27"
    sha256 cellar: :any_skip_relocation, big_sur:        "14bf0ead1c25d4b71c9644d15fbdc7384e1cec7117cc681af1f08e2cfa87eaf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9669a177b72e603f45c271fdd4c57d8ec37e8a1311f526c5827679455a42d079"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
