class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://sonobuoy.io/"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/refs/tags/v0.57.3.tar.gz"
  sha256 "d581032898c17f1df6db90e85aae8dae6429e8cd2a1b54e1728ddeaa7d9a989c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c32da42e3e5b57b9ced6921ad5c275ac8ff076ce9dbabafb30ba0d57d520a251"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c32da42e3e5b57b9ced6921ad5c275ac8ff076ce9dbabafb30ba0d57d520a251"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c32da42e3e5b57b9ced6921ad5c275ac8ff076ce9dbabafb30ba0d57d520a251"
    sha256 cellar: :any_skip_relocation, sonoma:        "a63e81012251bc72c4dee7f3c82fcded580417bfb68774d772980e5489560902"
    sha256 cellar: :any_skip_relocation, ventura:       "a63e81012251bc72c4dee7f3c82fcded580417bfb68774d772980e5489560902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11b4dd588a290681b0a297cdbee378b83cfcccb2bb8cb4c40033531e30b38d76"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vmware-tanzu/sonobuoy/pkg/buildinfo.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"sonobuoy", "completion")
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
