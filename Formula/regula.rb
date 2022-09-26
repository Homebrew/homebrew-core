class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v2.9.2",
      revision: "b41673e7b12a194969965c6a450b58a1bf263dca"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c93dfb33e51d1dc517922649778ce442a0803e707babaef8b0d31654a134c93c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a5173af76c35839829f988649d68a3d6a3106227d80891c282bd85842e0e743"
    sha256 cellar: :any_skip_relocation, monterey:       "851dcbe5d267c09b1b64d2464e0bbd761ab5a24b6f8bb230b8e70611f2f4af31"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d2fcea9ea5a34b78be9400d9929178c75fb7207da4b32dff2a4ebe3392ec813"
    sha256 cellar: :any_skip_relocation, catalina:       "f4e40bc48603ff64b46183b96c719ef5a5d02c21f4f5f52435f19ba27ae3d12a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad0de2fc459acefe703b91374169422679129b10627791618764b52ae3f283d6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/fugue/regula/v2/pkg/version.Version=#{version}
      -X github.com/fugue/regula/v2/pkg/version.GitCommit=#{Utils.git_short_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"regula", "completion")
  end

  test do
    (testpath/"infra/test.tf").write <<~EOS
      resource "aws_s3_bucket" "foo-bucket" {
        region        = "us-east-1"
        bucket        = "test"
        acl           = "public-read"
        force_destroy = true

        versioning {
          enabled = true
        }
      }
    EOS

    assert_match "Found 10 problems", shell_output(bin/"regula run infra", 1)

    assert_match version.to_s, shell_output(bin/"regula version")
  end
end
