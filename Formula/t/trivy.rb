class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.62.0.tar.gz"
  sha256 "2b0b4df4bbfebde00a14a0616f5013db4cbba0f021a780a7e3b717a2c2978493"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07a84ee33b66fadfa3cee049cb806485320435ec0dca3d6a221fd844e22e0899"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "581a3326e7eaff906da50a1db16eafcf506b318ea670bad184ee312cee30a351"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c53e7144adbcf2704a23da4ce8203e3715a94521cb8233c8afb2e65837909273"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d3fb7b05ffd15bb1c7b83a00a6475bef26142e30eb959e9edfcf1fa3eba2464"
    sha256 cellar: :any_skip_relocation, ventura:       "79b9e42e32105073d97b2d95f6d323fb6cdaf2bbbf366e8692b9f93165c6a69f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8a8cee2552df8f1ea04102e3edb641ee57334118b3bad48a6f17edb0c50cfb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7919218a49527efac932845179878753faafd93523e3a812ba460a9e6b747433"
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
