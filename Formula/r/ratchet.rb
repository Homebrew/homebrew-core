class Ratchet < Formula
  desc "Tool for securing CI/CD workflows with version pinning"
  homepage "https://github.com/sethvargo/ratchet"
  url "https://github.com/sethvargo/ratchet/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "7fe2adcf0f5eea0fdd80812d4a0bb20e0b7a4197b6c448191338214d94a8b594"
  license "Apache-2.0"
  head "https://github.com/sethvargo/ratchet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c705a0c2685eb55e6da67ed42bbb16904e9b67ceb0d61b3c53ccb595647fec7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c705a0c2685eb55e6da67ed42bbb16904e9b67ceb0d61b3c53ccb595647fec7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c705a0c2685eb55e6da67ed42bbb16904e9b67ceb0d61b3c53ccb595647fec7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "aabb2cf611a01e0a286b0930429ab484695c85eaeab1219416cc068fd61eb3ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30032255f9e022fc43dd536df1d31873c8f7a1a85991150a441b1ed0f5c67c92"
    sha256 cellar: :any,                 x86_64_linux:  "db48b4c5aefde4990c74090e3ed787d0f3c1ab4dc82797a72c425ab5fb57b2bc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X=github.com/sethvargo/ratchet/internal/version.version=#{version}
      -X=github.com/sethvargo/ratchet/internal/version.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "testdata"
  end

  test do
    cp_r pkgshare/"testdata", testpath
    output = shell_output("#{bin}/ratchet check testdata/github.yml 2>&1", 1)
    assert_match "found 5 unpinned refs", output

    output = shell_output("#{bin}/ratchet -v 2>&1")
    assert_match "ratchet #{version}", output
  end
end
