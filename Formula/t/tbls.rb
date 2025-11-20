class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.91.2.tar.gz"
  sha256 "764010e6a2c8d8121170dc5617d7acbcb8cbcb37a5e2c403db475d84f2b11cf9"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e624a27800b30b06f69105962c69e9409c8afe18722047dc7d1d1799af7199ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41371010ea04aa78835b638d7776bdc258aa509554b6c6bab7b23b2e262b3a57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "009bc8d85e7546e89948422f374de195bc293cbb8ee868622f3325f63ba083a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf4d0c1e9ef4d922a4b395212e8d297a7fcd7ddefa1e611ceae9fe1c23419180"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34393a7b6edb9adbf4dbbc2cf1cdb0578cf2deb1bd3df5393ad6a55443fa2024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bef0ac9c6ba7bd01666f59f16fb79394374445ddd8a0fc6853b96f6fef579de"
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
    assert_match "unsupported driver", shell_output("#{bin}/tbls doc", 1)
    assert_match version.to_s, shell_output("#{bin}/tbls version")
  end
end
