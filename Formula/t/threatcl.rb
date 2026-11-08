class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.6.12.tar.gz"
  sha256 "9e0e3360a63689cf495bc560376b4e3dd5709a86ba574762bafd5be74fb70aaf"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "db741eed4058b1bcba1ad2bb1b82301089077aff576adac95bf85c2228658232"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db741eed4058b1bcba1ad2bb1b82301089077aff576adac95bf85c2228658232"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db741eed4058b1bcba1ad2bb1b82301089077aff576adac95bf85c2228658232"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e841e52552cae8f2e7cf6f93d62fd03fa10df671eb315cdbdea9bc18f3a2fc25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cb94013a02b6cfe949646b537746435c2708731a6b33e51b2b5d59d2db91af10"
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
