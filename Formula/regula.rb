class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v2.9.3",
      revision: "a58739c76b3eaa0305df1eac71b38959041309e0"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d0d636cdd6bb54568881ac79a956faaff323c2b773668e902c71e32d54b1799"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63296224e332325d4fc8451ce6fa2be958dfafbc847c5326be3e0de71dcdecf6"
    sha256 cellar: :any_skip_relocation, monterey:       "1421385950ebe95182964b6e8a1c33468498292e43b096e82abe33a0192128f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "df12495ccd1d70e54924dd27740262ecb478a9e9ca803432d468a7501d8d7352"
    sha256 cellar: :any_skip_relocation, catalina:       "7688635f392851446c1157b6b75029ed1a723c979a2089fc77d61fee6f251e62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bc953e72d20605e57a262eca93c575138d945749879dc7324b1da512a6240aa"
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
