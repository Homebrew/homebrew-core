class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.69.1.tar.gz"
  sha256 "997f7b744e93bd2faa9f0c2f86345ab142d50d42a6ed2b3a35dc8b65676355ee"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfdfbe0f21f4154f49f8d5fdf0c4327e714230fc341a4e2751cd1215247c3cad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b54b36bae471129ffef453b673d718b46f000c4bd47190758b773f588344681"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d99a30929a9844d78ecfd5409ad4edfbe7d7e40fd7ab84d93b2fd4e2a4c53d5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bd5d184dc6cc181186c3fff48022b9b217fa73d8660f1735293a641d7aac297"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a46b9f048532740f728f8c013dc3efb3ffcaee98244e4d49f6ad5b4d43e3d86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b0f3ff84012ed461d29c40d2e28393f39c78d1bed39a6f45b56c405afc77201"
  end

  depends_on "go" => :build

  def install
    ENV["GOEXPERIMENT"] = "jsonv2"

    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version/app.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/trivy"
    (pkgshare/"templates").install Dir["contrib/*.tpl"]

    generate_completions_from_executable(bin/"trivy", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
