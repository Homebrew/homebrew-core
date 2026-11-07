class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://github.com/versity/versitygw/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "97d35b99ce46c23c56723dbc46526de17b3b23e33b00e8044e9e3f420a3927c4"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6992c8a63d1b23528cb0d1db7165e2e3e0d7499a677b99e0020f535bf9f56493"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "301f546a560332a9a8e09d4b8270fc2dc939a67c3a0a6bef060232c3c541bfb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "417033ad76a0b8b34888a59072d7cd36262fe86c8b09d74c66f5a02ae6e205d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a9013f093e0bbb24c21242746270a1710d00c705536bb9f5d5671a74f2f92b51"
    sha256 cellar: :any,                 x86_64_linux:      "179448d4626063ef55d579509bc242590cd16b39bc89301b2776dc33b9549633"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=#{version} -X main.BuildTime=#{time.iso8601} -X main.Build=#{tap.user}"
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
