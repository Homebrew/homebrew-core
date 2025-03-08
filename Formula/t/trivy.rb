class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "aab6a0b923ca144b9756e8ea2c23d9af06f423a94b25f28bd5543e786bf6585f"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83fcb6629c0f9540198a46dc5660e27c7b8e16a43dd994e1088bc6630e4371af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "779e1a322c06ce92711af2f30b68d7db4fd1df485e22af65968f58e0e6ec698b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "615347b2cfa17f68aed2220592f138bf0114cc72aea8778880be8dae1a30b381"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff29c2173aca987aef35854d5aa035eabe20c10a61ab6ca7454c4009f9b0e3f2"
    sha256 cellar: :any_skip_relocation, ventura:       "d7aa646dccf8ae2c317f911075d5653cc52284c6b2b4eab35e0c52cb1677b652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e03aef5ef9757bc6d884015d716b1bf1fceff0cebe8ce8f320722143f863a149"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version/app.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/trivy"
    (pkgshare/"templates").install Dir["contrib/*.tpl"]

    generate_completions_from_executable(bin/"trivy", "completion")
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
