class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.63.0.tar.gz"
  sha256 "ac26dcb16072e674b8a3bffa6fbd817ec5baa125660b5c49d9ad8659e14d0800"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "553c7ecfc23ee70ffaeb40e92bf7ca5675588f36590b15dfa8202fc5083fc3cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6793cf0ba88ea38553393491519f187b652a925c1997fa969d0e82cd3c25ea4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5212ff2cc82e772d7f37b0224e34668b56c31dec5d1ead21ab87871aa1d61376"
    sha256 cellar: :any_skip_relocation, sonoma:        "908d1647540c93eb4ce8522f7b39f7c0ba3cc2e250ae40c3b619419d19f982c7"
    sha256 cellar: :any_skip_relocation, ventura:       "f8b8e311f5d76bdb1eb924927957d7fc491099b3d557a4ccf1134cab236bbee9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be5c85315fe6b9471ea44f3044133edd1936d4a3842b8686bd7415140938c693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ec6b414fb7f0507dc48fb163e63bf0c6492f050f0914d11873477c28b8520d2"
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
