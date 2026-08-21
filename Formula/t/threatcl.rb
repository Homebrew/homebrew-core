class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "6abebd0b35a6f45de6c9f9339a47a22ff6fba377351f2b60a036df89cd52f550"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e75014851ad624724935ab3de1eec3372debcd84faac00c3a97927db2576198"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e75014851ad624724935ab3de1eec3372debcd84faac00c3a97927db2576198"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e75014851ad624724935ab3de1eec3372debcd84faac00c3a97927db2576198"
    sha256 cellar: :any_skip_relocation, sonoma:        "c883c0da7877239ba675ca77eb742d62440e16f921cefd2027c0ea8e24b23a6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8671b77d790158910113f1c935665f64c43eeb5f1a5f9dd0d3dbe0ac19b2da00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1b82cbd1bd4ea6c6a04bd1c562d52758210d138c4c5cb0e4a9b4ac00fa0e59d"
  end

  depends_on "go" => :build

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
