class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.57.4/snapd_2.57.4.vendor.tar.xz"
  version "2.57.4"
  sha256 "da1b6132cedfca6f3f9b3a8b99220fd8f839fda9efc35936bc1e1bce5515c7eb"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3ce499541f42599ac39991584069d00269b7789cffd73382c578348b9b765b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "692e23b12ffd695917a29f0c74b9448a9437052c9a558a63bc585f4a559d9784"
    sha256 cellar: :any_skip_relocation, monterey:       "63ad95ab3f5c04128ae523c643a47076d90a5596e4417c6fd37a67b1552f350c"
    sha256 cellar: :any_skip_relocation, big_sur:        "be8a8b3b8819b7a8d4b3f1d1ad95bd8b1f3b00b4e18378b0fd0cd6c3d87c6cce"
    sha256 cellar: :any_skip_relocation, catalina:       "ca6085bf0369e5f0968613f52965108dd9a22c44ead05e229c0d5f077fcad8a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "240ef2b39fe2dada2b9fef977bf2c11c7ca814ed365510d46ca14fbae377e9d2"
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
