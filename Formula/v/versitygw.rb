class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://github.com/versity/versitygw/archive/refs/tags/v1.0.19.tar.gz"
  sha256 "831f0ba33f0aa08c1cffe6e70f6092e0038824b9aa694db8a446492758505616"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b0361f1f8be319e198b0ee10c4c904387087a1175ef6c9bb75fa62d04e61ee7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f7640d823b30d5bcfc1e00ab3bcc20628eb4cef1f201427d94af376f7341ac5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8f4a2fe6da46c905f64d2c622fa6bf1ee6087889b2350c6988c948264d63b1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7335b98b31803fa21d830128a0f732f874c602f7e940e39abcf64718c35435a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28b654c0136e8f8d5901d0d5a655cf9dfd77f4469751b0579b5144609c456b8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f656103c4f5ad4cd8f53280da6202715dbe5e07241cd2491b52aa03aa6e50102"
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
