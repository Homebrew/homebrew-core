class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.97.0.tar.gz"
  sha256 "089d556bd7deb95516fba814063f01d4f35091665addcfedf05281c87b0cf145"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    manifest_sha256 "01291f12e63520a37fec4c2a2e7359f5b7aa0cbf2291bd35b4122970610f7b0c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a3d065dc9a07ff509c6bdbcf21d8f14674b378f9b26323e99e2c6f6399603f46"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "25bf0ff32d84e0cfe8f3ed8b2812199682cdd52ea0e132018eea8f706b05834b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7765be9ccee80b3f98731d5a8a85dc3937d8eca1dbbb1f4f202a1ecb56700d25"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4adddfc8d5c7873c6de94a1b3fc3a336f01148d721d735bb575176da6a66eda4"
    sha256 cellar: :any,                 x86_64_linux:      "fbed995cc170ef91022925ac33e4a8afe1013342ef7ba1b9dc4a710055b665e7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", shell_parameter_format: :cobra)
  end

  test do
    assert_match "unsupported driver", shell_output("#{bin}/tbls doc", 1)
    assert_match version.to_s, shell_output("#{bin}/tbls version")
  end
end
