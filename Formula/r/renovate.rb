class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-42.18.0.tgz"
  sha256 "50f8850b512d07e11d6d5b50f8405d8cc367f1bbb2f02cc59edd2b4a8bf34747"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a41e5925c887d82c557147bd865fca020bd6199d0b9a9e334656fd1af1d3c00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97185da31d3002a5a632f178af109fce7505ad3a777f4f387a60bc4a6e794d6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83282c94ed64dfe4428e2af3fe2747e9cee1dfe016a41a3ea2009db8f2c26cf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcf65b0126bac38c6eb05dc4e441cfee4d0573f3859a0ede063834dbe4769361"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b66d04cc02116cb3fabf7675ebfe08362308398aa2dc231c266e6096a1667c5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81bc36cbc74d8c060a0be440ad663561b4177829c5407d54567e4c77e8c9aa9c"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
