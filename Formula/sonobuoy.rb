class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.56.10.tar.gz"
  sha256 "c41f7207e5cc46e3635aa6e6ccd2e9be9527327c426be643418f30f4d9974ae2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "401fe9127247dc44bb802a1f6ad407a40ba1607f2c5eef25bcc10e47a74fd3f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b069882afe7e409946f172d35f5d0515a975b51e8770468f5602bd542de98477"
    sha256 cellar: :any_skip_relocation, monterey:       "f10d5ed59697357873107f7a7961f8125686498299057a226af8052497726d07"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e5c1981aae9873c6b1b7f7a13c1e6949a2a09f6ab6835fc22187bdcf4452555"
    sha256 cellar: :any_skip_relocation, catalina:       "9631cbe62aecd436989b7ac8e85e6830409365779330ed9e2ee3426121a8f244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a092bd8056953caa89cfb165dcd9d68052193d359b9bc268397e7c7b677c54f6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vmware-tanzu/sonobuoy/pkg/buildinfo.Version=v#{version}")
  end

  test do
    assert_match "Sonobuoy is a Kubernetes component that generates reports on cluster conformance",
      shell_output("#{bin}/sonobuoy 2>&1")
    assert_match version.to_s,
      shell_output("#{bin}/sonobuoy version 2>&1")
    assert_match "name: sonobuoy",
      shell_output("#{bin}/sonobuoy gen --kubernetes-version=v1.21 2>&1")
  end
end
