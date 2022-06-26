class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.56.2/snapd_2.56.2.vendor.tar.xz"
  version "2.56.2"
  sha256 "ee4096ef1a74a8d29b4cb7f43d442244beec413c21a517f34476270eb6a59fed"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd980cf85d89aa6407847fa8888c1f0f2d8f8fdd36daac087ded16a2dd779c39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "268da14b2a569357e64d20641b1faf9b024d3304a75f3131db832ba2ed28d73e"
    sha256 cellar: :any_skip_relocation, monterey:       "4582824dd62ae6274d5a83e3878f134839511cde0cff5f18f74c148312e4c798"
    sha256 cellar: :any_skip_relocation, big_sur:        "232b6be375cf1bf78c7cef33132d4073cd029c79179bc985c0aa2295d4cfe210"
    sha256 cellar: :any_skip_relocation, catalina:       "f93918fede7b55e6909cb6d58c57c24a0c03d7edcb5e39f7235d90066d85bd23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c153c49fc80cc4e97f2389b220bc0937f965235dee19c5ba0bddb902c924a674"
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
