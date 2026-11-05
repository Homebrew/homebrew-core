class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/traefik/yaegi"
  url "https://github.com/traefik/yaegi/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "1fca3442639e2f25fffc6d6cf104dd33a9c0951d32bf8b958ed6e2e979d32d1d"
  license "Apache-2.0"
  head "https://github.com/traefik/yaegi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3cbf327873c87dd167291cb91c5830d622383964fd3174c9c4ea9c89a09ab9c0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3cbf327873c87dd167291cb91c5830d622383964fd3174c9c4ea9c89a09ab9c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3cbf327873c87dd167291cb91c5830d622383964fd3174c9c4ea9c89a09ab9c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cfcaa670f4c0c3d43ce6f715b5e836ff727daef7a5baa3d16e76dca1df681cc4"
    sha256 cellar: :any,                 x86_64_linux:      "b806260f5a142706929d96e882ff6ca5bb01ac2f64e56c77128ac633cb15b958"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output(bin/"yaegi", "println(3 + 1)", 0)
  end
end
