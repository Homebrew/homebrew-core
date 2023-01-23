class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.58.1/snapd_2.58.1.vendor.tar.xz"
  version "2.58.1"
  sha256 "50569cf0d435850f6a5e495d6db9f6257ff1f67c61b0f1baa3d52f2938907393"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11699c79dbb8d2988f7cdb06baae6640f29924a135e49cd41a21b4dff3474b4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3127203425ed5c1bb3e7892f5ca5ac13eb6ea23748a50446320a6b8791a00cb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3eccbcff73b2a3bb246bd28d8b43c918b46962aace65ecbf294cad85b319558f"
    sha256 cellar: :any_skip_relocation, ventura:        "866ce0c85ec3b389ea1195a84ef7717a6cfe219569a451bba883aeac0e5dcd9f"
    sha256 cellar: :any_skip_relocation, monterey:       "c68eba501be8696a1c80a682ce970d254fc2fc29d2b6d350e05b3d69af931c8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "785943a9b855c45ed8aeca24d76768b6657240afc62748c8cd49399724795e14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cf119a3aaadd59b5d25867f72e33999bbd148ff894fe560b329c59abf322365"
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
