class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.30.8.tar.gz"
  sha256 "69b07d633ba2fa8674e2d0d72a7346c17f7a2fdc99d99e0cd86a799b018aaab7"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "44c417d4345c9be6dd3ca41645f1ca1fc57e45a8a5e915b748f84f7f8effda3d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "44c417d4345c9be6dd3ca41645f1ca1fc57e45a8a5e915b748f84f7f8effda3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "44c417d4345c9be6dd3ca41645f1ca1fc57e45a8a5e915b748f84f7f8effda3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3797615abf3cee3f42d73c0689f7d768b86d9f38b55b9c6733bcfacec25c957b"
    sha256 cellar: :any,                 x86_64_linux:      "06c59629b8ee73dd026284ceedcb23618246acedd784738077f0919832570555"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
