class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.6.9.tar.gz"
  sha256 "62e6fddf103881cd2aff415858d15f668fdb813f9546df87e781ec9f0d1b61a0"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "614a66e29ae6344d3bc4dff77094eb104eac941b52a7a64e76a8ef6effbebd6b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "614a66e29ae6344d3bc4dff77094eb104eac941b52a7a64e76a8ef6effbebd6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "614a66e29ae6344d3bc4dff77094eb104eac941b52a7a64e76a8ef6effbebd6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3b7e1a0aa70e441e31f71cfcc5b6677167e88a9f7a5c5bd4f161fef465fd39af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6d5fe3a04474c193ab338bea6e4f2d9a6434ee9accbab6c4a52667dc3a09f02f"
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
