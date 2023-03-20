class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.58.3/snapd_2.58.3.vendor.tar.xz"
  version "2.58.3"
  sha256 "7b8319b5ce1c2957651d0fec8c935bfbee02a1340927d9055ac1bdfdb9c1fca5"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccc3e981a8706725b4ca527e08a36a7e35a35d4d9bf5eb1e53569446944378ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccc3e981a8706725b4ca527e08a36a7e35a35d4d9bf5eb1e53569446944378ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccc3e981a8706725b4ca527e08a36a7e35a35d4d9bf5eb1e53569446944378ce"
    sha256 cellar: :any_skip_relocation, ventura:        "9009598c19f9faaa72f9c02ae21031d973d98979f8cee0c41a64ad48a02dd986"
    sha256 cellar: :any_skip_relocation, monterey:       "9009598c19f9faaa72f9c02ae21031d973d98979f8cee0c41a64ad48a02dd986"
    sha256 cellar: :any_skip_relocation, big_sur:        "9009598c19f9faaa72f9c02ae21031d973d98979f8cee0c41a64ad48a02dd986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a821c79feffe281635d58bf72b425c3a70c7976267ae3c81763bcfc75b900a75"
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
