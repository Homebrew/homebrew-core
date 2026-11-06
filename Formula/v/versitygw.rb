class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://github.com/versity/versitygw/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "97d35b99ce46c23c56723dbc46526de17b3b23e33b00e8044e9e3f420a3927c4"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c26a562dad2e624b1805a21f35831db836f9d885a05c5a39080eeb1596d4dbdc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c56507e93bf98121b0dde6a8a7458937e340816bb010a3e86fac3db85847d92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "331fb94c7a66f1ae91f6b7e86a5a0280f8e0415aafeb2bf7edf38fd58757da1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "097384fdb9b9792fff84ce251d6012dbfaf49b5d06868a2920e5601b665a4c38"
    sha256 cellar: :any,                 x86_64_linux:      "e049ca4c41f3e34d08933c61ffebb1da37e858256b1d4ca692ae93aed0f69887"
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
