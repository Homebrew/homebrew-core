class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.85.2.tar.gz"
  sha256 "74ad380e107f6c7999834ea041b2626030e5d482274816400d48ab5a489de709"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "821798f211971f15433e79224c7015179596bfb5415344f392c48138e6d0ea87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a8f3f910e96579129acd272c0cd562d14357c544edb3e71fb915d12487b38b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9984c4049e0cd5416f31f5b940af9399e0d0bf1377ba976915e285ee91bcccf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb3e3e2f34f30565dc02f1ec3e5631005d4a5ef48ea2e795cd84ddca103a91d7"
    sha256 cellar: :any_skip_relocation, ventura:       "09afac0e48f184ced4ea5beffe8944538803264f823871eb07d5e74cd60f30be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ada59ae79d2b42d0d0e24612adfaaf5541b093b95406800c95401ccfbbb747f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5de3a57b627a9efb09c2afffb773d4de9dd19abf0aa4f0e02ed588e7da848627"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "unsupported driver", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end
