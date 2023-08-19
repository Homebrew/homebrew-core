class Webify < Formula
  desc "Wrapper for shell commands as web services"
  homepage "https://github.com/beefsack/webify"
  url "https://github.com/beefsack/webify/archive/v1.5.0.tar.gz"
  sha256 "66805a4aef4ed0e9c49e711efc038e2cd4e74aa2dc179ea93b31dc3aa76e6d7b"
  license "MIT"
  head "https://github.com/beefsack/webify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4eada7fc709a5269b78b9f1c002a74e192be12631223a288be54e3fb64e0bbe6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a80b61c908b93e32695c8aa4cd4a3a1bfba81364cd8db7dff8dc5d46792240b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e846193c20d268355845e6d7e8e05dfc6f505749f6560d5ea6b4c8b1e4daf0f"
    sha256 cellar: :any_skip_relocation, ventura:        "99d3f367eb9e00999b733e1aff3ab1d8000b4e36885a5e74ca1faf44e96274b8"
    sha256 cellar: :any_skip_relocation, monterey:       "fa86b0d119e772525b310e2074115745dfcd4791ab9a8401d43674b5d7d09b43"
    sha256 cellar: :any_skip_relocation, big_sur:        "284df018b49ddc0c2a3b8e0800c1997abebee41d198edbd7d725be2f88a8c5e4"
    sha256 cellar: :any_skip_relocation, catalina:       "7b6543358b1c92e8e8cc71584ed52802a039c9327edc839dcc75216fbd23558c"
    sha256 cellar: :any_skip_relocation, mojave:         "8a58b27bcb9d6f9cd611b8f7dfb6192f617854cfcaf8638b388f6dd88ec40f70"
    sha256 cellar: :any_skip_relocation, high_sierra:    "9701f9952fb05880c48c5ca26d14807cf324c2210d4b45d0fb5408243d8d76cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bfcea38ac0326979bfc1c189dd9bf3c19437a5d92c8cade9a41f3c1fe976d83"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    port = free_port
    fork do
      exec bin/"webify", "-addr=:#{port}", "cat"
    end
    sleep 1
    assert_equal "Homebrew", shell_output("curl -s -d Homebrew http://localhost:#{port}")
  end
end
