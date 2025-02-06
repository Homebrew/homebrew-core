class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.59.1.tar.gz"
  sha256 "ead05298fc4a7d54f93045258fd4eb50d3751f8655094f65909221a07dc9ddef"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b06bef9ba29328835ef4ab28a50c4871b5e77dd61564a22a211d26da3888d409"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9866ee672b3a509161f29869b845a298c4982b1c42c49c63796d40e872344510"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15ab722b261c1d2d8e7bef80873fdd7f4e1d4513c6ed7af5dace30ed71a45a5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "410b9d49d0f2344869386d4f2038ec0106559b73a88fbb05c2af8df61f7f7bc5"
    sha256 cellar: :any_skip_relocation, ventura:       "42bea7ae648bf962fce6b10ce14da588ce45f7852a3a2feb400a3ac02d6c86ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d712bfb3e4a9ecb71dfa66a3da4fc5cf4d789b1ad3d2314f434c4a5fd6203abc"
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
