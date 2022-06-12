class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v2.7.0",
      revision: "d8928e350f9d7f49321716d75090be98ee6b7488"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "497654666cb671af0b0f120e77488a6f71f6166b7dc76d4a374d3709031d257b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ab499aa0aec14d8ee24a9258bda8a1246e1ff56e046b66b97aec8fa9a18cb51"
    sha256 cellar: :any_skip_relocation, monterey:       "fffa2819899f939bcf3749396635f8d134597744d284414886740f1ea609e198"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f5879a9293972d803d0305a6847c586fa89a502b998156c7deff553c4f1bf3f"
    sha256 cellar: :any_skip_relocation, catalina:       "7573e58ee89e2403934655f15f1549299c057158c52f5ea3b8c862f1f01bd758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bb3a0de7c3c9a7f0608a130fc57de707230759cc9055b2ca12ce588f6d12e0e"
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
