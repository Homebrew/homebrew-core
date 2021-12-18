class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v2.3.0",
      revision: "8bec0eda0ca5e48c54315a3330ff7714b8c545ab"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf3d973a8d3c309496966fb2e1a91f865a9a8ec9bb1ea26e134eaae37a17c4fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78fc3b3cebaf715eb8079561771703c6c31c67e7af131352626c5f13606eeffb"
    sha256 cellar: :any_skip_relocation, monterey:       "378a0a7e1804f8a2384f846d531f7704787db3712f1fcff69e7f3e209ffebb8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "162a8ae1604c9c8eec5c5c1cac6d4765929c0769f10a4b2e85dc14f6263ede2c"
    sha256 cellar: :any_skip_relocation, catalina:       "fa5d7decde7925ddfcfc034fdee70457827e0d937f21fad55d69bc83dc615922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a1817962621e32af7f136102d642e2826bdd6642c8cae82f1cfeb1bfa7b0ff9"
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
