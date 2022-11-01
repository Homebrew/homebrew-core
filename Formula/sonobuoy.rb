class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.56.11.tar.gz"
  sha256 "71319c8508c38ae6c78c886225b2d81653cd315f6c40354e030e8f4c4386b227"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52bf72af4c1d9374ebc54af3c091722c4b9fe927702fcde80f23434c7ba614bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "457cf15184430889c0e4110857f4a14456a782f17a8227a1169d1b560b55a605"
    sha256 cellar: :any_skip_relocation, monterey:       "ee127629100128a10f5a9800b1dca1bb066db244c37724a6d19080e414c76a4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "31529f8aefa3661eac80a67aa70ae50b976489f26d239b20bd254a992fa17cb9"
    sha256 cellar: :any_skip_relocation, catalina:       "62e996f87d2c7af262eecf4c13a46ce1878e0bb29205fdff5a5cf2ce87c686cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "144ac82fe76ee1383cde8f0fd62bbd9807b8479ed9f4e684f0a287740031873a"
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
