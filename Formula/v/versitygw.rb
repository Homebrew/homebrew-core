class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://github.com/versity/versitygw/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "b09759cc41d21974e11f882eb8cfea65fbe3e6d9dfd40a294763f3a185ad6f5b"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78a98e945a7d192d6a54405531f7a39eaeaf33d8af6f6260a23514330cc42380"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e31dccb1d042fdf8b0329f4fbbef1e6847c802ab04734a6917e1b8ba8e4ec2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f20dfcad42d77af5a28d987599d3dd18d0ff57559f0076487f12feeb1656fae"
    sha256 cellar: :any_skip_relocation, sonoma:        "e97ae8639c2a32cd5641da19fbf66ef50cd3899ea917027f2971c2e0a33fb4f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e551fe879a64e9faee713e4d6c1d124d77fb00cabcf12788c64d7a472cece2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67868826195bcb95d92a1f73d9b5a00b6d909684677dee1f48890d636201904e"
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
