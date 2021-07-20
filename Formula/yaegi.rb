class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.21.tar.gz"
  sha256 "96c08b7e24babe22098937efa78b0d9fd1f926ea42648b3096c286478cab3629"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2cd5c91d6a4f33ad8d4f2a54af69e9a01fcde286cd50288c1c00c6716d0eb778"
    sha256 cellar: :any_skip_relocation, big_sur:       "9b2c65382cfb0ea9ce1d56d253896408853eea61453dad8ace5e35015836dc72"
    sha256 cellar: :any_skip_relocation, catalina:      "b96f90fa875f79106523d998f8f51fae81d55c4e8998e53794d125b57c56b287"
    sha256 cellar: :any_skip_relocation, mojave:        "33a29e6479d34d5e92bdce6e3113d26bc93a704ccee31a429d14fb49d430a949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23237f69a60641b82b5cb95c0e140e5776c2165d68daf0a76ce5f184fd7a9aa0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
