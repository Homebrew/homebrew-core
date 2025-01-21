class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/refs/tags/v0.57.2.tar.gz"
  sha256 "8cc661fefbc959262991d4cc4076577e428d10b08aa0682ec32a5ff0bca56e07"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adcc616b8f507e2b0de352a29d4b1181811a972d32bfa076b5b12c00bab99b1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adcc616b8f507e2b0de352a29d4b1181811a972d32bfa076b5b12c00bab99b1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "adcc616b8f507e2b0de352a29d4b1181811a972d32bfa076b5b12c00bab99b1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "770e51d31207cb5b85d1e6980ed711e633fb92ef7c1a4084c625ea1334828dae"
    sha256 cellar: :any_skip_relocation, ventura:       "770e51d31207cb5b85d1e6980ed711e633fb92ef7c1a4084c625ea1334828dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e913c9c7c07875859a46d3a0fc8033e1c6c47f31d89c1074af0a8dbc783055d2"
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
