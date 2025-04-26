class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://github.com/versity/versitygw/archive/refs/tags/v1.0.13.tar.gz"
  sha256 "a050b3293860f92b5c21fe9350b3bb662882347b304289a8dd6150395d7488a1"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53ef750e7080a361ce0aa3d5c8ccdae5409a6b27af73d4bc46c5353ebc821d41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53ef750e7080a361ce0aa3d5c8ccdae5409a6b27af73d4bc46c5353ebc821d41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53ef750e7080a361ce0aa3d5c8ccdae5409a6b27af73d4bc46c5353ebc821d41"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa4e5453ac4238acf2af7326816350d08d4d406fd0e1f756c62debe69f5c829d"
    sha256 cellar: :any_skip_relocation, ventura:       "aa4e5453ac4238acf2af7326816350d08d4d406fd0e1f756c62debe69f5c829d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2da806afca3116e4381f8b2bc092c8fc07b4c1eeae250c4c644f82c48430d59a"
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
