class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://github.com/versity/versitygw/archive/refs/tags/v1.0.14.tar.gz"
  sha256 "315e45dbd1f5864860e96fd7548290bf505159602331048cc4ae0238f6e47c19"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a359af9f580c659a82458ebbdde5e3dfeb91d2e3684921f43f6e8f83de9f3ba6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7b764c77fdfeda4e1c26b4d0e17f469265a4a6f70f711017a10623c7218f15f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cccf493348843afc73af31701e474bb8bcb162553974117e0586fd92db6974b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dc49cc09142219b68970f2bffea7e101d68a940e06786020d5208a17d2f7615"
    sha256 cellar: :any_skip_relocation, ventura:       "c290a975ae0596f7fcece1524032bdd8b94ce95a51c019f7cb959710b2a68903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88b2dccc651441e7c16e512422d76d1d943c0fe76ccf897cadae90f2827a86bb"
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
