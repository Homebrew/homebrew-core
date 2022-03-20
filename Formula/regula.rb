class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v2.6.0",
      revision: "d73a69afc776db509b4822adb2976ba13bec1685"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9af837240cb5565f33c56878b35e901c0856ff5f8a66c1a0797e4d09ebe322d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86cacd41957eebef65432ad34f6c55d4a5eb033c9a7eb4cf45789c99b6b3cdd5"
    sha256 cellar: :any_skip_relocation, monterey:       "20f4b7293bb8d7964854f9fa1dd0d06f4c8b947023d42d2850af84e9631dbe33"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b9e47c79d15172cf9f18a1f65de541145493695b72dccb699e863bc75d20d4c"
    sha256 cellar: :any_skip_relocation, catalina:       "180695182d5a0d74a680e807684e31cfbabc8cf9828f27dd5c3e37ffc148a6f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fc8b59faf600c599a07de3c61cdb2d5e1d37159861eee071bc93da7e7f156c0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/fugue/regula/v2/pkg/version.Version=#{version}
      -X github.com/fugue/regula/v2/pkg/version.GitCommit=#{Utils.git_short_head}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_output = Utils.safe_popen_read(bin/"regula", "completion", "bash")
    (bash_completion/"regula").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"regula", "completion", "zsh")
    (zsh_completion/"_regula").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"regula", "completion", "fish")
    (fish_completion/"regula.fish").write fish_output
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
