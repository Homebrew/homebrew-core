class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.60.2/snapd_2.60.2.tar.xz"
  sha256 "cf1f30152614975b14be014d4f6e753705eec04a3d36b54960d528e9044ac54e"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "288ce9500915342376cf60a7ff373121b7136598b30e6e21c61a47eb61ae1c9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "288ce9500915342376cf60a7ff373121b7136598b30e6e21c61a47eb61ae1c9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "288ce9500915342376cf60a7ff373121b7136598b30e6e21c61a47eb61ae1c9d"
    sha256 cellar: :any_skip_relocation, ventura:        "fe5d3235d1546357b4698f3c2b597408bc3d1959119c688b84985934ca004f0d"
    sha256 cellar: :any_skip_relocation, monterey:       "fe5d3235d1546357b4698f3c2b597408bc3d1959119c688b84985934ca004f0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe5d3235d1546357b4698f3c2b597408bc3d1959119c688b84985934ca004f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b5d833a28897c20c8d6733d063ea8e80295c1013c8172a8dd01f43463a20db0"
  end

  depends_on "go" => :build
  depends_on "squashfs"

  def install
    system "./mkversion.sh", version.to_s
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
