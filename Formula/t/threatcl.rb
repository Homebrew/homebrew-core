class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.6.14.tar.gz"
  sha256 "41c5ce800380c877c7cc960d08c2d2d83d248a3a1ad9816b06c7685951aefb4e"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    manifest_sha256 "8b704a84fd267aeb23c7622cc9242ea52994b9339e2010b5cf1231ef76d218be"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "72337ab6c63942c8740a92f1ce52e2b60ac5cafb2ebb161d7ae9c8613d23ff0b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "72337ab6c63942c8740a92f1ce52e2b60ac5cafb2ebb161d7ae9c8613d23ff0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "72337ab6c63942c8740a92f1ce52e2b60ac5cafb2ebb161d7ae9c8613d23ff0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7f254ae524e39657b276627bbf33066234d5bda4645ab3749b953ea2671bdb9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "08271161a1d8070578f005e3b823268ab433ba4423639fd6a654dd54220d9be0"
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
