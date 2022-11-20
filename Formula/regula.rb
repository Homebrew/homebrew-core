class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v2.10.0",
      revision: "fd609494618b1666043b9359d2e476ed19f798dc"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b261d67ca404c8be063bfe82418d3fa3044a08f36eae92bdccae3afc08a87be0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e2fdac5836f0aa64e6abcb88f2f736a26291f320f852337fb39b5b1926ec7ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74cae3a17c89a88e44af2b1dc509790712195bbbfe406b64fed7f230ce6d5547"
    sha256 cellar: :any_skip_relocation, ventura:        "a5a77a73f0ad7539d47f201370124eefa09b20eabae63c149ef18c121cc950bd"
    sha256 cellar: :any_skip_relocation, monterey:       "1da8fad05e7aaab5d42f6232da82010f8c6f615bf11543fc05996338670c5228"
    sha256 cellar: :any_skip_relocation, big_sur:        "4951692971a42c581997b8637e085c35158abe691fe5dd4ceae59f93fd5a07f5"
    sha256 cellar: :any_skip_relocation, catalina:       "e96714e3085aa22f6a52dd64aa782e12c3ba4134c65caa8fd710455b34211865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a9129479f6af9b44e34494e56ee73174ac069b2cb0d8828ee9c3f9b8be892d0"
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
