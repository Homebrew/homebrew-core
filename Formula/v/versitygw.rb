class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://github.com/versity/versitygw/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "4fb0f24c0296fa04be170e964999bad7f101d0e71a2409a044e9f43053393e0d"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f37e0dd51c3c2d0628f2ac32e748a81ea1a132978e6dfd782ac769a644a5919a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3aa6de971fdcdc9b21f37f1ead55f80466ce811c6ecb84f774752d42866d05fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76fc125feef9af1a10bf53a8d30c1e12784ff61570adbb142ba8e4c6cfbb7f69"
    sha256 cellar: :any_skip_relocation, sonoma:        "751102a110a45752b39419d46ad36466995a3fdf6320e365c9f8584f0867d319"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be55a808564c07ebe5c8264f3272dfeaa5fc472e83af2bc30d2f766dd5cac9ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baa9962f4b13f88f3142854cc1680d4dbb74a7cbafd94f11325bb302a4569181"
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
