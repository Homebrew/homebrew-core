class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.55.0.tar.gz"
  sha256 "2f1db8498fbe7de614cbb7255c6680ce3cc57ddc520c74f6ecd651b9920e116d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27e2c48b5f44fabf2ddd94b8176f17bd1da68582fefbf55b803e7de8b9d429b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c52f9b1ca2b2f0dd1ec0eb06425cec68d8c00ed4066db97aef175f62ec94c16a"
    sha256 cellar: :any_skip_relocation, monterey:       "177fc1a9b7f47f94fb63ef383545c531804e11742764eec62418b9c355e4d190"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d0820c51132f00dbb200b65802aee8cb01b9fb6e162033ec6ca2c12dabd5b52"
    sha256 cellar: :any_skip_relocation, catalina:       "5ea27875f15df6ac8ab6e4c75394caa7aa64dcb65329805dc3f6848d5be3dc7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b7130b1c45d4aa24daef9168305abdf6a017c822568dd027bc2c1a2802e3716"
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
