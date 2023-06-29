class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.32.1.tar.gz"
  sha256 "be68a1b650db1f7ac35c6cf4fab0703f3a16e6b78dc2ff9eadd3ee67b8adef40"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e0500cb0545703bef2c03f43f0625926f45637b5b4df15cb9f94c3a20792825"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09b894abff89a082c60887bd4afe46f9c644514dbd1fba3c5c97ad519dc54fbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94e5d1239c70b3e1926496faa6c1fd7c8fb431035b71eb790982ef3205df3772"
    sha256 cellar: :any_skip_relocation, ventura:        "208a3a05277f0d61e58bbe58632e93ee1eb8741725a4fdbf104ba4922ce7f2b3"
    sha256 cellar: :any_skip_relocation, monterey:       "e023646b85e391fdca731a93d8d1bdb315c6cba9203aa09276eb400d9760f507"
    sha256 cellar: :any_skip_relocation, big_sur:        "af51f5c31455fbd26b876286223b0a937091e83c1723f43656ad0589869ebaaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0d568ffd515b12708c9d6448c99903c60bd9f45442f5b2e42f67c297dfdb1df"
  end

  depends_on "rust" => :build

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
