class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://github.com/versity/versitygw/archive/refs/tags/v1.0.18.tar.gz"
  sha256 "d4271f8b98d6f1d722a1ddc405777889013b9111afee60b5f00887cee861fe95"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ed3757d781784cba1cc2d468f821a9d6e2e0d44f236fa1578d7141c460eb49b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f3af83211ed29a6e80e527f4ff862c69ceb40b34850af1d00289949550f9189"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f98492e184a6715bbae1cff23908bfb942d2effe2539e63ee320f0df31f94040"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bdc6dbed3e465e7ac7cca06fce1da77fa9b42f7436a18fe76b06cf6475af0b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a0c2ffe3642acd703a6dafc99515b90afae8b8c6243ef0dd0bc527e81f7cab8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildTime=#{time.iso8601} -X main.Build=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/versitygw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/versitygw --version")

    system bin/"versitygw", "utils", "gen-event-filter-config"
    assert_equal true, JSON.parse((testpath/"event_config.json").read)["s3:ObjectAcl:Put"]

    output = shell_output("#{bin}/versitygw admin list-buckets 2>&1", 1)
    assert_match "Required flags \"access, secret, endpoint-url\"", output
  end
end
