class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v2.8.0",
      revision: "611dbd38f7df934e8001d11d52863d73cf0ee266"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bafa1dbdf904dceb7f1b02f140fa897ac4abfa0ca2aef36f7538f24cf2f1ae6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ce0cc7083faf220e0efabeb95e1e5d265be89c6ff0cbfd240a600f1fd9258b8"
    sha256 cellar: :any_skip_relocation, monterey:       "354da246c053862bd9ddd9691fcff789b3dd875a127dd2221445728d4e027b00"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8aa1569dcc008bb99d65b9ebeae0eaedac00389556bd518a65ff8bdda594390"
    sha256 cellar: :any_skip_relocation, catalina:       "7be23165956985c1ebaa3fc5643537877c5b34807d15d03311768584bad378e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cd042ff096af3de962fcc4e11e7629f3a86e0d254315e2c3d3e600588dd489a"
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
