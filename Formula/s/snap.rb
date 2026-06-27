class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/canonical/snapd/releases/download/2.76/snapd_2.76.vendor.tar.xz"
  version "2.76"
  sha256 "78ad358dc685ab5a40b9ca0b3fc283ae7c8fbbabb4612182d512bde7efeef605"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92599851a72632849a6ff3e8b98d2a7081a4fada1bcdaf5b9ef327bba2250d7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92599851a72632849a6ff3e8b98d2a7081a4fada1bcdaf5b9ef327bba2250d7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92599851a72632849a6ff3e8b98d2a7081a4fada1bcdaf5b9ef327bba2250d7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7aa84103fde25f7556684986927a404c35d7f60be4e843f48f9e1cecbbd56a11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3d6a31cd6389022f5b8c18122117b47be83387447bdf5582bca2d61815a1433"
    sha256 cellar: :any,                 x86_64_linux:  "cdeab768af092b8ea38c2ca94a94f408f409a2e88988a9c3c23926078c39ef26"
  end

  depends_on "go" => :build
  depends_on "squashfs"

  def install
    system "./mkversion.sh", version.to_s
    tags = OS.mac? ? "nosecboot" : ""
    system "go", "build", *std_go_args(ldflags: "-s -w", tags:), "./cmd/snap"

    bash_completion.install "data/completion/bash/snap"
    zsh_completion.install "data/completion/zsh/_snap"

    (man8/"snap.8").write Utils.safe_popen_read(bin/"snap", "help", "--man")
  end

  test do
    (testpath/"pkg/meta").mkpath
    (testpath/"pkg/meta/snap.yaml").write <<~YAML
      name: test-snap
      version: 1.0.0
      summary: simple summary
      description: short description
    YAML
    system bin/"snap", "pack", "pkg"
    system bin/"snap", "version"
  end
end
