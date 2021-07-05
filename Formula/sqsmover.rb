class Sqsmover < Formula
  desc "AWS SQS Message mover"
  homepage "https://github.com/mercury2269/sqsmover"
  url "https://github.com/mercury2269/sqsmover/archive/v0.4.0.tar.gz"
  sha256 "217203f626399c67649f99af52eff6d6cdd9280ec5e2631e1de057e1bd0cdd0d"
  license "Apache-2.0"
  head "https://github.com/mercury2269/sqsmover.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "af88364e07133113f9edd4fb5d93dce01ef57c934a79a61c9b631193fa5df55e"
    sha256 cellar: :any_skip_relocation, big_sur:       "a22d1ea6a666d648d77fc688a8757be60125a66b3c9250b7e04b96f66c7bbda1"
    sha256 cellar: :any_skip_relocation, catalina:      "2e0cd9bde59865a7a1c8900999698135845017d76ba359a07ccac8554d0fb937"
    sha256 cellar: :any_skip_relocation, mojave:        "7fbc42e0fbb2e7fb96d13aef9a50c75e1cd9f80240d0e978ee6a58a1e3b38724"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{Time.now.iso8601}
      -X main.builtBy=#{tap.user}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    ENV["AWS_REGION"] = "us-east-1"
    assert_match "Failed to resolve source queue.",
      shell_output("#{bin}/sqsmover --source test-dlq --destination test --profile test 2>&1")

    assert_match version.to_s, shell_output("#{bin}/sqsmover --version 2>&1")
  end
end
