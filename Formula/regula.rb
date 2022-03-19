class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v2.6.0",
      revision: "d73a69afc776db509b4822adb2976ba13bec1685"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44e7d41aa5d94a7cd8db2382da8c46771e9eece9551e1b7eda78c453da382e5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "653752a60f08222b044fbdacf7852e30fbd1c1d4a7635bcd6ed0d3ea69fc91ed"
    sha256 cellar: :any_skip_relocation, monterey:       "187e75b29cb8f3a083f1c13e9b4ef5b23b0bc1d066a9e3409be02bf152a533b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "41f0c09b3f6a2b879af1acc7cdfff98c25b5f80d2cf91882ccc7c928fd9d3f7a"
    sha256 cellar: :any_skip_relocation, catalina:       "29f7937f5b7480473d686ff6a3c0a378fe815b476387a44f1688b551e51b45cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a04343e498507f6a1ca9f86044be2c4fd731d682afe30a5cf9385fe9b01eed6a"
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
