class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v2.4.0",
      revision: "b66c18f7ab22ac8317c5a1508837b154375e39b8"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65f04262944f787bc14be90dcd7560e4fdcbf4b42e3207347cbc99b8d67b7aa0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6b217b611569d62cc29a4aff974c934a10787a62cd8961cc3c2e2ab8f8031e2"
    sha256 cellar: :any_skip_relocation, monterey:       "acb3380926a53b5c73120a1f4e1c60525598ca172604d2d9399d2e4b671ae1e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a45bd25b9b8501983aa081ff17f5bc57858cef3f42341648d93940bad4fe8ec"
    sha256 cellar: :any_skip_relocation, catalina:       "f114564d4b14183bdb016db5c2668ca5a1b70c897c2d6fefe02139548973d548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "079598c7d5f792f76dc7c6da1e12e17202951ecc2687453d2e97f6114c68ab14"
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
