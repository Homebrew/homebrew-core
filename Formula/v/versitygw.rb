class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://github.com/versity/versitygw/archive/refs/tags/v1.0.12.tar.gz"
  sha256 "c0f47e93a948f153d2b1f4f86ea99f7365f2487609e8e0de23577bde5246154c"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0839eb2b1a32e8e8b602346cc54a270518bc03b3d75779ce2a0ab6fc0f6d6a18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0839eb2b1a32e8e8b602346cc54a270518bc03b3d75779ce2a0ab6fc0f6d6a18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0839eb2b1a32e8e8b602346cc54a270518bc03b3d75779ce2a0ab6fc0f6d6a18"
    sha256 cellar: :any_skip_relocation, sonoma:        "6610c730b56908bb0b0b7ad2886ba2778f200b030094e53abd3ae5b09006029d"
    sha256 cellar: :any_skip_relocation, ventura:       "6610c730b56908bb0b0b7ad2886ba2778f200b030094e53abd3ae5b09006029d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e0fc4a0d666c2e3511054413b4e5819627dc04156ff5455eb66ae9486736741"
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
