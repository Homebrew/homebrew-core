class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "1e97b1b67a4c3aee9c567534e60355033a58ce43a3705bdf198d7449d53b6979"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "162a0b89a9e8f1a850e529891c7104d30a6f3a10f17c9eca8f0ee798213c44b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d11de0a9955ad13e1986e72119aee7073ff520117a3b19f92df30e2d67aaa695"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b5275b6ed7678cb9e5e37c992d979e2fb6d99bd8be719f64f93de7cc0bcbdde"
    sha256 cellar: :any_skip_relocation, sonoma:        "05b6c438064bbb47e5b9c23f99f8e06845e8b0324607e197ecff1d1e8d021f3a"
    sha256 cellar: :any_skip_relocation, ventura:       "645abde218b00107d806f8c09d486b8ebb34e9f0a1f5f4ca469e640b481af83a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0f88a5ab162442772c152a0423577dc94039d24599eeca2fbcb2013a6f67538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab0ca52719c49f1bd9619834d5c398772be3d2b7a11e8e2a48c05c09c0feac11"
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
