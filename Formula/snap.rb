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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6df68da04f0a55938cca94e2cca9385c1d076177e3e5266e4c14e6482e742f52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "432eff97078ecabe4aef25178fe37153f7493246e66b7bd835d0593c00e9da68"
    sha256 cellar: :any_skip_relocation, monterey:       "07192cae1626edf1fb85fcf2f314086e8b5abda6a88e6621a3e37b495773d5cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "67f149332b22ec44baaac32306cdcd1ab4c417788758a49e4c7f3c12ce451af6"
    sha256 cellar: :any_skip_relocation, catalina:       "4d3a32a1fddb8f4c82c02ca533fd4d4af8602a462073e825577ca2b0aa4fc4c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c4e527d7fa7c3333047dd4c15bc2d9bf9115b1a0a574dac4f6d214116ebd585"
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
