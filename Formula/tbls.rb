class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.65.4.tar.gz"
  sha256 "010dfd2f2f36ff67c1c698dc31677bb2434dc8577ba12806d9d8174663b9ccfb"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4905611673c1eb68ad77f782134a09c6563ead448c72c2894de5f6d426de923d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50f09b61009f980463755523e48906203af10f228f264fb6b056a153d77b8860"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af9f4d3629eb22b0255b10636f45fe30db7397db265c86abaf9bdc96657cf80f"
    sha256 cellar: :any_skip_relocation, ventura:        "02b6a8084faa341df1eed282225064cab2aa91d5107b45fd5edd60a8e4438ced"
    sha256 cellar: :any_skip_relocation, monterey:       "d4af4e789f253b3ed562e6810533a16381414166fc1229c92c5c95be856e998e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c8a4520cad9d90b744c2d8a25b5e16c30c3742683e78fac59ed5339a11fadde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e472bd8718c4c17cdf0b286d93578ed3c63b5b39aeb3d285923c699d1f93cd53"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end
