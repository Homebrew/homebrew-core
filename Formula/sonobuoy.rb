class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.56.13.tar.gz"
  sha256 "5567f60aba3346b77f022362382756b23127e5dedc6de5068e865cb5d9e3606f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "894ef27e7469c7c58f9c8cf16e2393d7d0ebb4e093ce5cc9ce4b1da831964e95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7787ab390ce76f4957050b82c7fa941d4f8628ba8e3025be0e3939b5a5e2c41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0dd0a7e3482e59a0358e952554a7d192593a90077d73e0abf35dfa110a2a82f8"
    sha256 cellar: :any_skip_relocation, ventura:        "7a3fe3124a7f9899b6c1f2eb08cd22bc0a815909dfb8c6a3db59000946a86d03"
    sha256 cellar: :any_skip_relocation, monterey:       "0b7c647e1bd1276fda1c3d0f4243ce916764aafe3b8d5cb3f7b35d1fd043cf6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c19655e3a3b6058e3a79ca08ae5024707f9ed58254e8b392ed399c02c6c9cb3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36a5bb33e9a1f77c6aab3f84f53dd4d2c649e3c6a19deb417ffa2a505d37543d"
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
