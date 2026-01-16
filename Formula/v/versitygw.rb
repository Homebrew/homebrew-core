class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://github.com/versity/versitygw/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "4a52ea2f297a8cbed98cdc8b2d2409a8b400996e091d639c384cbcb35afdc77c"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d10293df8fe748a2659f00748714b631a9d3e584cc1eeab305d3bb8fa27b63d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "354c09e1ee459abf4bbf314148f20df2a5e16c41d06a81f76e6b489e3ff25140"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f88f1a588e5ef9ce613af83d4b0614d77d806f6d3799ca5af7da691e2740810"
    sha256 cellar: :any_skip_relocation, sonoma:        "19d2af5c40d5349b7e9cf0872c8802b6f24d98ea2225d8069c740072b9f6b51b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b811a19e14b7694b763785f9ea941c2915df91edbf1885d6c9ec9b93ffc0c8d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "998c5a8300733a4ddfe93ca4c805a724980ebfc88f6eb0588178ece3e6b2bd07"
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
