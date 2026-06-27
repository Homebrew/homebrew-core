class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://github.com/versity/versitygw/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "6621fe4c1b3a644ac37ef923078be570aa71292396b879db67549b29ed4d0616"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6dc1c94891565c7651ddf5f9689ca16e71a29f3556a2a0ef56b9a4d0905aa7d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d7d0dfa616d99ec712a1e8fbf95569261679fdc06544c91261e2d3902144ae2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8052f264968feb78c4cee3b203b497af063ee745a0762a051ce18bd3a834a778"
    sha256 cellar: :any_skip_relocation, sonoma:        "81634a7e99870daa59da6e026c8106f94ec26e86f968878cee67cac7b3f81289"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d017dc4fa25ad742518da6ee0d0f583d6dbb001ce6ce1b07ed092f27927d84a"
    sha256 cellar: :any,                 x86_64_linux:  "9e0f694362c0be14e7544ae26b2fa0d00f3852d106a206fdf59a03963111bf4d"
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
