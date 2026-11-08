class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.6.12.tar.gz"
  sha256 "9e0e3360a63689cf495bc560376b4e3dd5709a86ba574762bafd5be74fb70aaf"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e3ebf62e15ca957c29b345e3cd274ce9909d41976f402b316b9ca2fa824145b8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e3ebf62e15ca957c29b345e3cd274ce9909d41976f402b316b9ca2fa824145b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e3ebf62e15ca957c29b345e3cd274ce9909d41976f402b316b9ca2fa824145b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8ba04680f268d42fb2ea12f1639e9306f85ea930251a02663a26e43d4a9d7a3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2d84ebe4e8f87e5631799900ecaa34627e507eb059613f22e9670e8cb95c0d75"
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
