class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.30.2.tar.gz"
  sha256 "aa36c922c75e8ba33ca2e444473842c1ee96210993ddc2723f5f3d7b6203f3cc"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de83efe307f70910f3104a29669f4802b5b112de080c5bab358e428c0fa3f494"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "caa185a00510a9984c1b73471e755d39495ecc8214df1685bd80c3326f870feb"
    sha256 cellar: :any_skip_relocation, monterey:       "0160ae153625832f91a7d977deb0b7f313b337e4037fdf31b8beb3244490ee0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "68520a9f015e77704581af37f9f2b27904416241dc036eb845b508a592df9009"
    sha256 cellar: :any_skip_relocation, catalina:       "6d86c1efcd9cf5ae5770546d551f2b1a523b771d44496abbbd31c40e8083a64c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "068ad043598608210628b9c14260c92b5b524f031910f673777128d6ba050cc0"
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
