class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.30.13.tar.gz"
  sha256 "dfd155a802e13df08423aea54a6c8337ec4fbfb4f83151ec2e0aa59bc0793170"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    manifest_sha256 "5f165d2e0b9a1981085a5f511a3c0f3eaa6d5cc59becfe9de2160aeaabe6b972"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3d3caa90987bb53cdcd39cb766aa8c3e157a64584d05823321b3147d78338807"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3d3caa90987bb53cdcd39cb766aa8c3e157a64584d05823321b3147d78338807"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3d3caa90987bb53cdcd39cb766aa8c3e157a64584d05823321b3147d78338807"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "12cfee0121caaf6e9c101933972ea2da7a0cc4ff993b74eac4f866a44c8bf494"
    sha256 cellar: :any,                 x86_64_linux:      "4862416a4c297fc00e66533d70f017bb32c4e7d8934bc85665ca86f952b05993"
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
