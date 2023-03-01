class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.38.0.tar.gz"
  sha256 "a9093e009d969feaeb33718b55d2cf3f3efd68c9b598d11562ec9554e3eac61a"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20c1b673d62f30d6e0baf00396808a3181c00afa8c1d0a9eef1d0ad4fa0ebab6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffa10102b7c0466dceade3db6e0030c234d9870bab15436f3935de3304c9db91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0778de54f9da9349b88b99edb467e780fc10e31074c1afe7a638033927c3b06"
    sha256 cellar: :any_skip_relocation, ventura:        "791e1514a65df59fe54083d7df1354c5bb6914348c7106ec832ed45e58e2b883"
    sha256 cellar: :any_skip_relocation, monterey:       "4ccace9258eb582af9530b886e90662402548458a6b09ddb913f06393ba853e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c87364e451fd90fe87cf80de31c4ab3acad1da0d9337e5d1296fcb86653dd7c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0c7e2508a415306d275caab1afb0933ccf777a58f6dae834b7e1cf4735ba117"
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
