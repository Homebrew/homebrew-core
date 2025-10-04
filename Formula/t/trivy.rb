class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.67.0.tar.gz"
  sha256 "dd72492b04af1a6ebc5e1eca3ef957b59f570b47ca9c00c379e9ed51bc612541"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26d2669d6cbc5bdc88ddb3dc7f27e4b21cecdab32db50adb101c76c5eecd1070"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f53dc98cb6ccd0285a67ece919334ce307576407cb50e4446d3be987e6b5848e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d74d5da331eb0b7c640ec53efc3dfd0ab0855549c1466f4ef46e91728f8a7458"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b41d4958384872bc1b82912d8703d2cf40b079270fc76ecadc11bd5acade1f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b34b23aa8567796dd7e52c9171ae5aba8fc3d5839b1d6f11788a9c4abf622a70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa7f56ea82235a666f4981424c268485bb3f984943d119441ddcde296a479f7f"
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

    generate_completions_from_executable(bin/"trivy", "completion")
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
