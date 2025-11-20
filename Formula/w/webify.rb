class Webify < Formula
  desc "Wrapper for shell commands as web services"
  homepage "https://github.com/beefsack/webify"
  url "https://github.com/beefsack/webify/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "66805a4aef4ed0e9c49e711efc038e2cd4e74aa2dc179ea93b31dc3aa76e6d7b"
  license "MIT"
  head "https://github.com/beefsack/webify.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "58f65712d5c510614847dbcd64d5e96fa1728a35de3f3a31438aa644ed02afe6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "73fc38e24f8531f3ce47ffe71e79edee8f691a0f7c936263c4c32bc4a873ded3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f776cc31325713ba672231fa075d461e4efbeaff7f10ff49b15671c9003ae0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4eada7fc709a5269b78b9f1c002a74e192be12631223a288be54e3fb64e0bbe6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a80b61c908b93e32695c8aa4cd4a3a1bfba81364cd8db7dff8dc5d46792240b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e846193c20d268355845e6d7e8e05dfc6f505749f6560d5ea6b4c8b1e4daf0f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee516a9a392724609863042f96c8bf2ff8a8ad0ac941f89813a02ce746348765"
    sha256 cellar: :any_skip_relocation, ventura:        "99d3f367eb9e00999b733e1aff3ab1d8000b4e36885a5e74ca1faf44e96274b8"
    sha256 cellar: :any_skip_relocation, monterey:       "fa86b0d119e772525b310e2074115745dfcd4791ab9a8401d43674b5d7d09b43"
    sha256 cellar: :any_skip_relocation, big_sur:        "284df018b49ddc0c2a3b8e0800c1997abebee41d198edbd7d725be2f88a8c5e4"
    sha256 cellar: :any_skip_relocation, catalina:       "7b6543358b1c92e8e8cc71584ed52802a039c9327edc839dcc75216fbd23558c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ec575d86612a39bd2e879f5bc7d6ae16e8787670d66c8c23da15df7d09f8d378"
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
