class ShuttleCli < Formula
  desc "CLI for handling shared build and deploy tools between many projects"
  homepage "https://github.com/lunarway/shuttle"
  url "https://github.com/lunarway/shuttle/archive/refs/tags/v0.24.3.tar.gz"
  sha256 "4a8b93f01e9e21e543c393f59214145850895c89c2c6924a7faac6f8f12292cb"
  license "Apache-2.0"
  head "https://github.com/lunarway/shuttle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5e8bb4b72731ce957e8642a4dc363c0119c12298a191e3f774d130e0d947db0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6239f4fa616ca21a781595b6da437d6debcb1ad013242c33c3a54aba9764da64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6239f4fa616ca21a781595b6da437d6debcb1ad013242c33c3a54aba9764da64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6239f4fa616ca21a781595b6da437d6debcb1ad013242c33c3a54aba9764da64"
    sha256 cellar: :any_skip_relocation, sonoma:        "5aed20ea25a270dd87249277003e75da31e91988fb461b95596b727bb35df25c"
    sha256 cellar: :any_skip_relocation, ventura:       "5aed20ea25a270dd87249277003e75da31e91988fb461b95596b727bb35df25c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0b8712fd91bde4dc653e8e37e4cb0030b864707178c2ec10b358fea9b14a0ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be0bb28ca0505b75b4c6606f528eac6a2b6fdbb1e40e1ed3fb788793114daaff"
  end

  depends_on "go" => :build

  conflicts_with "cargo-shuttle", because: "both install `shuttle` binaries"

  def install
    ldflags = %W[
      -s -w
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
