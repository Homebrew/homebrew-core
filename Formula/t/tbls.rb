class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.74.1.tar.gz"
  sha256 "a09cff822e03131eab984655bdff21c197d09d94810f3cc12b5cdd3a7e2d629f"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8dcc3e956660d0ea174473724cccd049981d44276cd80657ed6c1f231b4b2208"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99b2727135ab76f47143b28f5f7ecb151af6005e08079b8b65ae60ba0cf4f746"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66de91b6ee4da4b843bbc2858a44bb865382e33256858113e7e6bdb7850bed8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "058706899064502c17c78304295da107e0cc366e6c7ae59f6bbde0ddcce00982"
    sha256 cellar: :any_skip_relocation, ventura:        "b139b82ca35a5730ebc2b6a0655235449dcba4c687ea06d7bbf1f7237ecd2eea"
    sha256 cellar: :any_skip_relocation, monterey:       "17a3e711076919fc631e3ee1825aa954a9dbf211b476bd788f46958e6ad9feda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4adef017a27179e529a689632a6af2574e5386237dadba1a78981219711b85e"
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
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end
