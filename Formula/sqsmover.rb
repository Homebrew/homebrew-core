class Sqsmover < Formula
  desc "AWS SQS Message mover"
  homepage "https://github.com/mercury2269/sqsmover"
  url "https://github.com/mercury2269/sqsmover/archive/v0.3.14.tar.gz"
  sha256 "4faf5471e1232bd3d5d38de38836fdbc9786f01d123901be71441334478403b3"
  license "Apache-2.0"
  head "https://github.com/mercury2269/sqsmover.git"

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
