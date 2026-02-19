class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://github.com/versity/versitygw/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "f950add37c4f6cb3004fdc2b1986a58a44e352277032a7725e9b7c89dcc6a4bb"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18e1a5db7ae6e2f2be7cffa2719b0198ffe91c5a7866d0611b4c75d0940bc488"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d175e46b5c6d7b2492fe3a455443927b5b81dd05f335d63153330e02ff75abea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44166680eb9fe7c37527709eaf6548ff088d4ea39db8a49394a2a837e1f029fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "98ddf3f44638b3c64f8f52ac702953d7b4dc908693c3ddf185e4dd0613e1260d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b47226dd4f7781e5bf4b0440ceeeacd39ce13795b44a8084fd0f94ad25143bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d53f34477d7a02561285d6206b8b04f00952c84aeb4fb52c1d5d42705ae475c"
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
