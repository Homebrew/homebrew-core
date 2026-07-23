class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://github.com/versity/versitygw/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "7e63315ced171ced2dc32482e8c2916121bdf77a63c0ef3e3124d6b5e1b2201a"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25b5d433dabcfa2b37488a3e09aefb67c745a8bc328d8afe6c84a83d1c02db96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbe06fafc183695542cb75396c268782f29a22e8d0d6ffc0c15c7eb22f9121b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10d4eca65b63c045ac50537f1fb92292f7e6558545213ac0fb1782718cd8761c"
    sha256 cellar: :any_skip_relocation, sonoma:        "deddf026e3817a1beb0c3ed7fda3ff85851529bd592424d3b500e9c815fe54f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c771188a12df488d9a254768d7bb8513fc1ca824d697aa6b256bd27453a71499"
    sha256 cellar: :any,                 x86_64_linux:  "43b01f7c1b1e31f8eb5a1ec875ef03fd0f8cca3f6c3f6ee030baacb90d240a06"
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
