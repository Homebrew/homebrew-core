class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.56.4.tar.gz"
  sha256 "5c3175d3aca408ff8e4e77b716b95ca0be0859fe600912919d3897cdbbf77bb2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dfb75a03623471ad07da92a8d0d2e375739751415d43c6885e5a67165e6a0bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8509a78551e03f91cf3f7dec1f878a74b24c999a7fd622c55099f010600c0bd8"
    sha256 cellar: :any_skip_relocation, monterey:       "b31002f99e0926ad22f455e0c7db2b564350c9b9cd79b6d52b2e8089feebfc67"
    sha256 cellar: :any_skip_relocation, big_sur:        "027f159e331b4d4ef1c758b1d5ac18972caf0262c14ac243740d31cf076180df"
    sha256 cellar: :any_skip_relocation, catalina:       "ec2f81142931b130b96f27e873c501155ae9da02dfa104ab30ce094228e00860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3ed63fc6bf9c035431ac7dbd743cf378604b1c2f84dfec68eaefc98bc131f7a"
  end

  # Segfaults on Go 1.18 - try test it again when updating this formula.
  depends_on "go@1.17" => :build

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
