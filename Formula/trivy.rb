class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.37.1.tar.gz"
  sha256 "d13832058065d9d788835cccfe0bc917fdf45b3ede1033e23ca2f72977d67ab3"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce4400cf2c008730204811faf604a7b252a7f057b6936d9eab3bc8cb2392bcc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43b2af92f4cbee8f6df5b8cfef3e6b297085e784fd14f828054ed3767fe6fc3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9026b6d35867f1557de611054a9ff33901bcbc03e89831e046a3790e98ebeacc"
    sha256 cellar: :any_skip_relocation, ventura:        "3377f0b2a416f756f20d006b2cdaaaa41cc1ba92f21d7287034b8b641235212a"
    sha256 cellar: :any_skip_relocation, monterey:       "641daea7a50d6511353edde05454ef9c69a1cf39bae1511018db64c30bbf4d38"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a011b72e80dd5c157482bb5bd04e5cd6baf2d84141185442d1883cadee3ec54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e92fa6d1fbd9ad17ed0c705ab648352e4063d69a4378d7f5ef488a9ee01da53a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
