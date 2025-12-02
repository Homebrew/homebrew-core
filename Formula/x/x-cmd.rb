class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "3ad7638b4970d697797074429122deb953596c1c7e127144eda30c95b8c5af1c"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "142aa2c66a0b9cf1c48e13965a727b777d2a9441d572bb0ac539c847956dbc82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "142aa2c66a0b9cf1c48e13965a727b777d2a9441d572bb0ac539c847956dbc82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "142aa2c66a0b9cf1c48e13965a727b777d2a9441d572bb0ac539c847956dbc82"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc92846cb07473d545542b0bb716a73137d20b2366ca729e9c8e193237a874cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "118d9b998585d0cba45641ab7a331d3114ea4f05bbde44dac4adaf189da10192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "118d9b998585d0cba45641ab7a331d3114ea4f05bbde44dac4adaf189da10192"
  end

  def install
    prefix.install Dir.glob("*")
    prefix.install Dir.glob(".x-cmd")
    inreplace prefix/"mod/x-cmd/lib/bin/x-cmd", "/opt/homebrew/Cellar/x-cmd/latest", prefix.to_s
    bin.install prefix/"mod/x-cmd/lib/bin/x-cmd"
  end

  test do
    assert_match "Welcome to x-cmd", shell_output("#{bin}/x-cmd 2>&1")
    assert_match "hello", shell_output("#{bin}/x-cmd cowsay hello")
  end
end
