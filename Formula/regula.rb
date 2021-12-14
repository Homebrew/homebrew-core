class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v2.2.1",
      revision: "fd6b3c923158fb1fe399449ae3c84cc9872cdf73"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef98fe6f06e434f31826194de3c530a76e2522ee55e7648857c06ba7cec50068"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d3d68108029e1cccef1354c81b5002f15f7c42a7fb5a1bdd6115a5d3af6131a"
    sha256 cellar: :any_skip_relocation, monterey:       "11e8c602c8960b0cb1a86d258e37fcc6fdb4a5d712d60bf8e806e05c508caf2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "304dfe2e9d67c9e0a1356600ae35708708fe672d97400a896653c0cc5a9ff623"
    sha256 cellar: :any_skip_relocation, catalina:       "c6c8497f708d10663a4ac939dbbc9e73f77bd7edb9cdaa3e12915d6e4c7fac74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c48ff87ea2d12cd3e25b4868e4d713a1e1c1a47545e63b19d65d82fccae428d7"
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
