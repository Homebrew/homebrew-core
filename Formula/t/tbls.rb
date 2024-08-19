class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.77.0.tar.gz"
  sha256 "6be85cfa82cf3a75bca03cd49739307f5ca60768624742f7020d36a1c5ee4984"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6da8e73bca45626743a2ca70f804b6d12341b05f5d1b6296dec6ec0cf184b4bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25e51da66d33ef3c048864332ab0c38897f63c17dca1e14b2daaa0cdf6ae49c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bf0cf6e99568be62eda198f42d992a34d6c209e9d557add40eb639dc19d3ce1"
    sha256 cellar: :any_skip_relocation, sonoma:         "feaa5c5ed5578da0d4a94c55189a3a8cf27aeaf648e8a9647580680ef95e9720"
    sha256 cellar: :any_skip_relocation, ventura:        "f7de3c7a37947ccee1238862db198bb83bc1298406240de6b9957d91a7d1ab1b"
    sha256 cellar: :any_skip_relocation, monterey:       "27176cb8983988e1a79fec9ca87d06cb57680ce14d1e52ef05d76c81f408cc63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c7160e5109a7eb06b6bb51dd83c7f0d8a377020c343c033f3d51257c598a591"
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
