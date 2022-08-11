class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v2.9.0",
      revision: "5193f8781c63e5f79dc8981f7ee9dfa35585dd9e"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b526a0660d2e6bb8c411bd4cbcaafbb3874a53a1e7c3584773b110bf1329df7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b569d5f3ca275eaa87e645f7f2b9924edfcb921434f4f15d1f154048dcfd821"
    sha256 cellar: :any_skip_relocation, monterey:       "5e22d11e440c4d346b9d73cb3cc30954256518d497bf666dbaa23b2d48c70d1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ee7205738458ca9946d46e29b688d0bcb3e058fc9bae49ada5a64fb3032de3d"
    sha256 cellar: :any_skip_relocation, catalina:       "5f7ae6ccb63daa5194a1d1fbc625a8e3336901e41494fdc0f4ffccb731d77d9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe8e7de8622472f22d56f95c3d1592c929c901e1bbb79acfa2d22eb4e72d68e9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/fugue/regula/v2/pkg/version.Version=#{version}
      -X github.com/fugue/regula/v2/pkg/version.GitCommit=#{Utils.git_short_head}
    ].join(" ")

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
