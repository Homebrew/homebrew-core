class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async I/O"
  homepage "https://github.com/sxyazi/yazi"
  url "https://github.com/sxyazi/yazi/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "aea4a6ebd7f56c5d5fe6afbea143fc98c336d4ccd7852f2e8983c23e205988c4"
  license "MIT"
  head "https://github.com/sxyazi/yazi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2dd1283e888475f107c48f9ec5df45d6d0263502df80c87091f6038f3cf442d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b83b98aa0e9e85404e3acfc98aa5cc364f83d319b08a5aafad394275cc30d24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51deba176fe060e79ecae1b7bdbe12067161d4c0979421d62e67701770da7ac6"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8a389802aaa39009b019c21591f27cd34c29eb536f92ecd61acb71cfff92b5b"
    sha256 cellar: :any_skip_relocation, ventura:        "9467bf91431b390cb8c0c618e4900ffd2642bbb6cf0da76cd6324bfa32d04c4a"
    sha256 cellar: :any_skip_relocation, monterey:       "105f8274fcd8cdfcc4d3433fcaa6183dd6dbd36325a9bb4efa66027edf99cd29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0e9cc4e06368e643617f8f54350ab3e3b486131255e5992513a31c5d780c78c"
  end

  depends_on "rust" => :build

  def install
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", *std_cargo_args(path: "yazi-fm")
  end

  test do
    # yazi is a GUI application
    assert_match "Yazi #{version}", shell_output("#{bin}/yazi --version").strip
  end
end
