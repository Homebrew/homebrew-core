class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.29.tar.gz"
  sha256 "dcc64e0011478279de5ca9650a1b723077805cceb820bf14a3074a8b0374419b"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c681b2cccabcec710da6a1bc3366b66293278297afc4345357812dac2400174e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6939785258a1c5d1ef15a8b01bb62bf7800e72b43f815012ca58ee685fede76c"
    sha256 cellar: :any_skip_relocation, monterey:       "0b6aff0e25d82762e4d0ef9c504a46dc2430e6d60c75f9f15aaed1bc9827d4c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "76baedd6cd61e33e1b34fd55bd4edcebd31fb321ab14894794215fa954602f0d"
    sha256 cellar: :any_skip_relocation, catalina:       "e29cd5693229cc8f17e8cd95c4c62cf00f1410909f99740273ffdcd30764aa57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dee5ea1d650bc2b53ac211be84d64b1010feb9719cf4f37a5f998739b4b52bd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end
