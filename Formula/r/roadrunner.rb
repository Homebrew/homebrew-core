class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://docs.roadrunner.dev/docs"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "9a2572b0eb6f8c2dc58915ca483a0c97a91623a20d7ed2233fa337adf66e89b3"
  license "MIT"
  version_scheme 1
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d{1,3}(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "d6f15ab1c874f34f509c29f0ca266e2fdb4e87559a51c602ffbe29ef6703662a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3a2125c0dcaed1dd9a32c5b65bb947cce16b66d78c3dcafa43ccd82f9bb1b129"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "31553cbd7f78a186d4fe4a050ea0ce4865573deb8996019c67edc0daceb613b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "05857ab91d1dc04338863606665c39fa6184e051970f72122a57f5eda359ec0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e258647f2d5930bca31ba1e345c7e130328ba1dc4022eed08387b607f0a2e773"
    sha256 cellar: :any,                 x86_64_linux:      "8c94819eb2697b8483bff9ce8854a6a0d27e5018eead6f9c8709ab8d16719238"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.version=#{version}
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"rr"), "./cmd/rr"

    generate_completions_from_executable(bin/"rr", shell_parameter_format: :cobra)
  end

  test do
    port = free_port
    (testpath/".rr.yaml").write <<~YAML
      # RR configuration version
      version: '3'
      rpc:
        listen: tcp://127.0.0.1:#{port}
    YAML

    output = shell_output("#{bin}/rr jobs list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/rr --version")
  end
end
