class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.69.3.tar.gz"
  sha256 "3ca5fa62932273dd7eef3b6ec762625da42304ebb8f13e4be9fdd61545ca1773"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8896cbac7e3358f40b7abe67282f3e48edbc968c7574109718623282c8e613ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "978f24b985c15bbede6230a4677eef11f1d174ffea452aec4450f966ca455782"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c75d8581f3803f06899965fc1f679a57cefb33011843e52fb358483641316e47"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3a4b53fa2665514ee3354ee466c73e068b239048cb1553227e18e61cae64cee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ca6c5adf4b3cfe7bbade34a47853b2b51277a5e1e616964d230c25d547594c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22d76c73d1df4940c4582df814d58b8627f88b0a4762c3a23fcfa28003bb688c"
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
