class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://github.com/versity/versitygw/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "0ac3f5f81bcf8833a9d5c4bc134721fa95d7f062bd48eb1ed18bd5edd738e78b"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f71bc89111ba03d053d89d7111ebc0cf73a50a076da5c1552bcfa3d936ed1880"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5714755c8fc59ebb42275f409d78a1b157264f69a679bd395caf833cd198e142"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a7c767bef098c5c62dc3cf285a8701fb30ce80848b462c0fbdf92f11f1dff09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5ed0d51d5944941cdf251cf4760d4e30e22fea6abfaf30f3642fa8e37a95eb6"
    sha256 cellar: :any,                 x86_64_linux:  "28e1ccf97e95bf635d0ea1b146ccc6b645053798b7536d53cf90e1fd430cf0b6"
  end

  depends_on "go" => :build

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
