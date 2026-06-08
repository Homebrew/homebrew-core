class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://github.com/versity/versitygw/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "6a667e38d78a08effdf0b7c3c3e4b9929233b333c8a53c16b62eded7d43eeedc"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb897c2ee8beb0a6eb36f93214f96b0b12da007fd655ecff30600f3b24ac9f38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "265bbaa265ae5335c8ddf45f8da3578a9faf370476b8341abf9b606a284862d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "050a16a43543344b72c4878d92b0a7c2bd815d8daea0e232140245ba85cb8dc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "44b3110702abca7a7aff9cf074cbb64af9d987ba69b83fa3de2ef58d44ed6683"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ac4b64a6fff7deb5255fdd12463f51aae868194932ba213e57f94ecec68a5df"
    sha256 cellar: :any,                 x86_64_linux:  "913cae105ded92c4cd592e701ff1fe8393cf7d08fefcce7b6940299d0bbfa261"
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
    assert_match "Required flag \"endpoint-url\"", output
  end
end
