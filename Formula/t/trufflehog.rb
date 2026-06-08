class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.95.5.tar.gz"
  sha256 "323ab881ec00c80e787cf57ba2ab8a763dbadbc8607944f36b9cc9f3641473f2"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38ab8e4feadfe638f86241ff390cd3d327d979449515204beead027fe3d00e3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "075c1b8274e3a62553bd2e53559b671e3ddb03d47c4e6097c8080f74307619cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "552c68cb20ce955bd2e8d25a218d3e48e0872aec0b0fc0e3ef5e3f91f74df71e"
    sha256 cellar: :any_skip_relocation, sonoma:        "243ff1cf4b8f92183a43fb1cda2eee8915a872cab179b0221dced21cb9385bd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e15a73e2aa2b5939c3bdb05f5d6bee078a1e349a7eae439b4c96e68728488f1"
    sha256 cellar: :any,                 x86_64_linux:  "be8d8e0b956af224b5f569e30f417d08368fd7408cb2c00407c529886e67e32b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "docs/man/trufflehog.1"
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
