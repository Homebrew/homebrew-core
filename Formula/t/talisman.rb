class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "7f3a04e19381b00cde566627382b4cc0fcf9c5fc08722ea6b965d9fb3b0be7ed"
  license "MIT"
  version_scheme 1
  head "https://github.com/thoughtworks/talisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2308daf58a46fe8ac793154973ad81b449803d1b12f0fd1e104dd0aa06773604"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57bf2a73f616e104f41a3b7a05a5752d312830493485d027da64fafe60152ee7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57bf2a73f616e104f41a3b7a05a5752d312830493485d027da64fafe60152ee7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57bf2a73f616e104f41a3b7a05a5752d312830493485d027da64fafe60152ee7"
    sha256 cellar: :any_skip_relocation, sonoma:         "d131501e4509d9ce24f6474a8b1fd8fa3609c41e9f255a296708ae311e140a3e"
    sha256 cellar: :any_skip_relocation, ventura:        "444f77f5f1b89e55fca68a47bf114945e835e71948f079c72fd7b871a0ce960c"
    sha256 cellar: :any_skip_relocation, monterey:       "444f77f5f1b89e55fca68a47bf114945e835e71948f079c72fd7b871a0ce960c"
    sha256 cellar: :any_skip_relocation, big_sur:        "444f77f5f1b89e55fca68a47bf114945e835e71948f079c72fd7b871a0ce960c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5257fdb40f64459d31eb200005077c5fd0bf43c6506e9357dca967aec8532709"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
