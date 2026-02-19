class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v3.2.1",
      revision: "fed1e441b187504a5928e2999a6210b88279139c"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0495a23cf7487740bfb918ced57eedfaaf47768bb8499e369434a060b612d4a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0495a23cf7487740bfb918ced57eedfaaf47768bb8499e369434a060b612d4a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0495a23cf7487740bfb918ced57eedfaaf47768bb8499e369434a060b612d4a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "03a0738fdd999c084d73ca360ff1caab512eb61cf3df26cc5ad03821045cfe65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad755b9efc4d3e1513548ec6272d496d3212f8f8e727290bd8d795bee6a1a961"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b284378ae1275d96ebae8ddf706301071bb6d00fceb70983c0795871dc973ee"
  end

  deprecate! date: "2025-04-27", because: :repo_archived, replacement_formula: "policy-engine"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/fugue/regula/v3/pkg/version.Version=#{version}
      -X github.com/fugue/regula/v3/pkg/version.GitCommit=#{Utils.git_short_head}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"regula", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"infra/test.tf").write <<~HCL
      resource "aws_s3_bucket" "foo-bucket" {
        region        = "us-east-1"
        bucket        = "test"
        acl           = "public-read"
        force_destroy = true

        versioning {
          enabled = true
        }
      }
    HCL

    assert_match "Found 10 problems", shell_output("#{bin}/regula run infra", 1)

    assert_match version.to_s, shell_output("#{bin}/regula version")
  end
end
