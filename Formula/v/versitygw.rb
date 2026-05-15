class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://github.com/versity/versitygw/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "bdbe036f282aba67ff179795f4eba2115106237d88a9453bea1ed3353f5ffb5d"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0dbedfa835d6e8d94c4b505eec0690cfb20fef1d1a1d0cdf856f5bc76bfca18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05953fa4cd9d90ecc46668c37913c68669878fdbdde516d0baa5820304cf810f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e5cf94c0b9170704da7e374f05ffd1e24ad44cd79d2d76d508b1729d7d27ec9"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b49eda926fc8997b7f871d1429f167cb5e8d1a01a44d21af7f0f8c4a6eee25d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff662026ef6901f4d230eaec3211950f2d98c08a694ed89004a84aeb59128675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1440c4a016476e0fb0bdb1240e1b3d59e5bd9183363ac4dcb8092518c5437795"
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
