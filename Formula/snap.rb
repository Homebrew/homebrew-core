class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.57/snapd_2.57.vendor.tar.xz"
  version "2.57"
  sha256 "b0e7df310dc434a1023846a62cf2c6338f24b9a7a9101189d1d04ae148029919"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8768db1d269d4924df9165651bf84dd1596c0d2e2e0c3d2b9e3b4d6f0429ce9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37baa998839ec2a5a1c169094aa7dc4c91bfa7c47a8f465bb58101a0217d3da1"
    sha256 cellar: :any_skip_relocation, monterey:       "378692f5e9eccaead19700de5bf5157afa3aa25983d1aef55f439f0866a3eb76"
    sha256 cellar: :any_skip_relocation, big_sur:        "687cb9d5cfc950ce3bcc5140c8268b3e3a4b4c04522b3f3f05d9504c53d05336"
    sha256 cellar: :any_skip_relocation, catalina:       "2b82410d9908ee6b0627871ebbd7d60b8cbbf0827c3fc9bd703850927c239f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bf1a0c33c422b24345f3f4d20eaf1fef2273690e4744797e1a2c8fbb30ca70f"
  end

  depends_on "go" => :build
  depends_on "squashfs"

  def install
    system "./mkversion.sh", version
    tags = OS.mac? ? ["-tags=nosecboot"] : []
    system "go", "build", *std_go_args(ldflags: "-s -w"), *tags, "./cmd/snap"

    bash_completion.install "data/completion/bash/snap"
    zsh_completion.install "data/completion/zsh/_snap"

    (man8/"snap.8").write Utils.safe_popen_read(bin/"snap", "help", "--man")
  end

  test do
    (testpath/"pkg/meta").mkpath
    (testpath/"pkg/meta/snap.yaml").write <<~EOS
      name: test-snap
      version: 1.0.0
      summary: simple summary
      description: short description
    EOS
    system bin/"snap", "pack", "pkg"
    system bin/"snap", "version"
  end
end
