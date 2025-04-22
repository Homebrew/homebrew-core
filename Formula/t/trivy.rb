class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.61.1.tar.gz"
  sha256 "f6ad43e008c008d67842c9e2b4af80c2e96854db8009fba48fc37b4f9b15f59b"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42c284ff54971e8c4031545168d95e618a625862d28c5b07749fe11bc482cc87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30a261a9b25cc195ca4841e6b4c69d671774990eae34613032990ea2ce3055ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e61c634f22824bf3c26f5b419410db4f32e99f7410cb74720b2460cc5719c870"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cb79cd19f4f4029e386595e3e994bd6e27db6bc9af121a872819e31529639cd"
    sha256 cellar: :any_skip_relocation, ventura:       "dfefb6ae9ee692e8d15686b2ad3fce3dcb7954cdc3730541326ffef0ece58572"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d2e41f268de250f4daa03269a3bb61d2849daa1bdbac11ba6b2766b3db99949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa42302492eb8940eeeae1cf898d1cce2a5248ea092ccd6c331a55ae5f329b07"
  end

  depends_on "go" => :build

  def install
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
