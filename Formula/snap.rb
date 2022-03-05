class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.54.4/snapd_2.54.4.vendor.tar.xz"
  version "2.54.4"
  sha256 "c00a041dd5665cc5e3d6977e0a53ac896cae1cc73c93ee9c5339efb17264bd39"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25d8527f1355b4ede1a9c05717008529ebd44f371e9c487b14e6a3b18d31affd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05aed1d92ca7d14266db8ee36a350549b451f6abfba7f9628c52f35a02e7f518"
    sha256 cellar: :any_skip_relocation, monterey:       "81f52a44144aba1199f623e990c47c0ede3121f1ea9753a9c0308a21dc6d0261"
    sha256 cellar: :any_skip_relocation, big_sur:        "26651c464dc63fa9a11f0f219a2deded168b19cb26757471e71de5ecd3648011"
    sha256 cellar: :any_skip_relocation, catalina:       "5581ad2a4732c8b5a56c06f9c24aba39ebe2ecc9f3cd9e3995d8b8e1dd40761e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8bebe56fd8a29e2d631417627644161e821f4042b112b741af82178a2f0aa0a"
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
