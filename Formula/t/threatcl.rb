class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.6.13.tar.gz"
  sha256 "835771e72a34efc6823fa478d22e3fb1ea4aa55c27b9857f642d2e2eaed9942a"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5b36d0039018f5c2596503113ccce894749c8fcb23c9cbdabafe313242e2c2c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5b36d0039018f5c2596503113ccce894749c8fcb23c9cbdabafe313242e2c2c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b36d0039018f5c2596503113ccce894749c8fcb23c9cbdabafe313242e2c2c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "610c44a545d1db570fbcdadbf793c9c8b6032d45921965dccd2083cee8ea7fd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0f327a03caa968f761ee2a95871e0d81cfcb872265ff20d19ac2efed43b51542"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = "-X github.com/threatcl/threatcl/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/threatcl"

    pkgshare.install "examples"
  end

  test do
    # Other examples remote-import files that need `allow_remote_imports`
    cp pkgshare/"examples/tm1.hcl", testpath

    assert_match "Tower of London", shell_output("#{bin}/threatcl list #{testpath}/tm1.hcl")
    assert_match "Validated 2 threatmodels", shell_output("#{bin}/threatcl validate #{testpath}/tm1.hcl")
    assert_match version.to_s, shell_output("#{bin}/threatcl --version 2>&1")
  end
end
