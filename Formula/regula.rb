class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v2.4.0",
      revision: "b66c18f7ab22ac8317c5a1508837b154375e39b8"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff52d01b868231fc73c918433637d27b541a82ab4edb637c897efd01f2496c37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9d51c686388c28636d47fb0325cb4f848b435dba0ecd4e594be8a44c1f6e994"
    sha256 cellar: :any_skip_relocation, monterey:       "fe56caa576ac6037fde345cb0ad267cf5787145b698369664fa4f1091e95c28c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f7dcad209e547ae1561a6403803465b95ce8f57e88aab567cc332224b38c0de"
    sha256 cellar: :any_skip_relocation, catalina:       "443f537b1240f86a8ed718fee5c1d10aca0c62b2246cb6609067055bf0c9081b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48815019477feabb29f159c6b62cea1f287a92c920550693cccef3ebfe5908d8"
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
