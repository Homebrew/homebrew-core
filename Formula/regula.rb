class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v2.2.0",
      revision: "8aa865e2cba7eff7615881daeafd5e79f124d878"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2be5eaf6c740d205638b653b885faf0a501694aac71f016db39c72d46f6c17ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8972e8f5f4be7f47495aede4938c83f9f4a82b834943d05ce7102ef1e8871c9a"
    sha256 cellar: :any_skip_relocation, monterey:       "fe98dc43810bd05f5937b7b114a394464572a1db90dbd068e963e1cfd2d59c00"
    sha256 cellar: :any_skip_relocation, big_sur:        "f20ddadf1de1d44fb7251018a54cc47b59e44401acc4536f0420ac366b54790e"
    sha256 cellar: :any_skip_relocation, catalina:       "7097bc960b6e0cc6f6be2f294f498035074e637896221897a20496cd9d705ea0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a530cdf0417c8a78912d3de0b5d160e34b0d81e9f7f23ffbf1b10a57df4d0e74"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/fugue/regula/pkg/version.Version=#{version}
      -X github.com/fugue/regula/pkg/version.GitCommit=#{Utils.git_short_head}
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

    assert_match "Found 8 problems", shell_output(bin/"regula run infra", 1)

    assert_match version.to_s, shell_output(bin/"regula version")
  end
end
