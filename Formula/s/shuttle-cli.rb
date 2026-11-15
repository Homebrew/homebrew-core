class ShuttleCli < Formula
  desc "CLI for handling shared build and deploy tools between many projects"
  homepage "https://github.com/lunarway/shuttle"
  url "https://github.com/lunarway/shuttle/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "a7b6f4b0642ceef9fb3e1da96ec65a1784bf520a380dcd95992371fab4416a30"
  license "Apache-2.0"
  head "https://github.com/lunarway/shuttle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b42db6a5913fdcbda428184902ed19bfe684dd978a04053d86ef52e8802cbc46"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b42db6a5913fdcbda428184902ed19bfe684dd978a04053d86ef52e8802cbc46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b42db6a5913fdcbda428184902ed19bfe684dd978a04053d86ef52e8802cbc46"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c67919f591e02ac1db10320f8fb235c05fb7359648f5a10e853ced59f9e00bb4"
    sha256 cellar: :any,                 x86_64_linux:      "d57f8975647e08c0471263914968370a4af0077943f019eab89490e00906378a"
  end

  depends_on "go" => :build

  conflicts_with "cargo-shuttle", because: "both install `shuttle` binaries"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/lunarway/shuttle/cmd.version=#{version}
      -X github.com/lunarway/shuttle/cmd.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"shuttle", ldflags:)

    generate_completions_from_executable(bin/"shuttle", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shuttle version")

    (testpath/"shuttle.yaml").write <<~YAML
      plan: 'https://github.com/lunarway/shuttle-example-go-plan.git'
      vars:
        docker:
          baseImage: golang
          baseTag: stretch
          destImage: repo-project
          destTag: latest
    YAML

    assert_match "Plan:", shell_output("#{bin}/shuttle config")

    output = shell_output("#{bin}/shuttle telemetry upload 2>&1", 1)
    assert_match "SHUTTLE_REMOTE_TRACING_URL or upload-url is not set", output
  end
end
