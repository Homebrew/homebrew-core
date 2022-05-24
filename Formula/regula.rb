class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v2.6.1",
      revision: "0d40e66c4bec929779b8bb5cde5f22ed1e522ede"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "919052268835599f20ea4b1006a81a9e38a50414a0b4fece905ed9aaf827d9a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa7baf097bb2894cf0ac6d2b678b00ff3c45130d4c4024a7a2667a520de35798"
    sha256 cellar: :any_skip_relocation, monterey:       "3aeee6c0d1003333c98792a133850e1f4405a70716c0543ed74602642c63157d"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb56580f8b9d12667426daab4e0c8f9bd54fe14abc8e4a66dac1c87a570f13bd"
    sha256 cellar: :any_skip_relocation, catalina:       "ab3ff7b13f7350fea29d003d2fa8b9ac1a0540dcd90d2cd305b6b0cf35c41b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57c424db92c8e96bd7fcec0213ff370d1cd07c27391bd07656ecf5e235a242a8"
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
