class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.55.1.tar.gz"
  sha256 "a8e90bed7498a676d9a9d528529f303d58fd76bbedc5c32ef40722c50b0f3f17"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5813fc36342657a3e1a6cde18ac3a4ac6cef21e9ba368013845d0cee6afece1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb5367fc618d5f15fad4036e4ceb4dde589cb9755bf48171d2f42e293006403d"
    sha256 cellar: :any_skip_relocation, monterey:       "1d52dd1f692fa5ffc648f9eef2e6fe8ef69ff6aeddfacc55cb7ecff61889fd1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d52adb0c4f553165c2afd06e7aea346b8da4640d95fe16d16cbaeeb8c3f9a9b"
    sha256 cellar: :any_skip_relocation, catalina:       "38d4b0d1ca2db9358fa783aeebdbbc3956817f7503a79ce558c2a91cd16602a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a87246f89d1f74dd9e54c81b2e441f76d0ec937b3094818d5e8d1e8feaf2b78"
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
