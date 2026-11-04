class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/traefik/yaegi"
  url "https://github.com/traefik/yaegi/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "1fe741797b37cdef32662f093b3042c1dd4e06fafd086450765dd0a9f4fb0287"
  license "Apache-2.0"
  head "https://github.com/traefik/yaegi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3ef4c7e9d576346da96ab8c5c831982ecc731598456ccfadf07a7e40ccbeac17"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3ef4c7e9d576346da96ab8c5c831982ecc731598456ccfadf07a7e40ccbeac17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3ef4c7e9d576346da96ab8c5c831982ecc731598456ccfadf07a7e40ccbeac17"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6abcee117482329829701f7f46a599310c0b8f30323012bafa89fc11f784c128"
    sha256 cellar: :any,                 x86_64_linux:      "d5aa723c6f7fb462daea83d1869e87d1b36659554f2985cec9a3813a0a8e99cf"
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
