class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v3.2.0",
      revision: "eccea56cea0b4cb64e29367360b07b8a2b27d967"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31f9d8242642d1733d8bd3acb61adea884ee2b37d3981c3606200fddca7421b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4e0adc0e9550e43d71519691e1e1fd1ba21d7d2e4d3c9b63491312664c25b14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc0804d7530f5c9389d2061b6ec87a33e42ffbd337ce106049c01d1442387349"
    sha256 cellar: :any_skip_relocation, ventura:        "bda8376ba986f076c0ffd1056fa8c8d7bdf4c72a51d2b6c546296affbc4ef9b2"
    sha256 cellar: :any_skip_relocation, monterey:       "db8e932d775b73de60ba612a4e7c91cc952ed71adf7ecd2f7772831b86460fae"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb4ad0d0b4648d76ff5cd7564b50e724b0060a00b179f3403e343d18c33430c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41627eacebff5f87a7e56a732650987f6db6710b3bd04e04fc8e714a9772050c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/fugue/regula/v3/pkg/version.Version=#{version}
      -X github.com/fugue/regula/v3/pkg/version.GitCommit=#{Utils.git_short_head}
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
