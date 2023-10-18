class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.61/snapd_2.61.vendor.tar.xz"
  version "2.61"
  sha256 "af30dc20c09872bf42faedb8f5306abc85faf9e3b010cb2388086cbc42a0909a"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ecc6acfc69a838dcc8522756a1b8f49b224f16d08b796c3dcd29dbc5312369e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "815dde6f13470b4d6024a9b300715d1d6f60b95ffbb37a918e657e724e28a458"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "566f8fa03c403b9fc6ca25d046500dedb158391b2bcdc75c7909c1fdf90b568d"
    sha256 cellar: :any_skip_relocation, sonoma:         "829a7d76b014c05d9303a45c273f57c5143ab10c12d50734407aae0e3149f8de"
    sha256 cellar: :any_skip_relocation, ventura:        "b2d4813cbe1116866d6e9459bdc3f4054408c8a70e55c5a49d52d1a52fba9670"
    sha256 cellar: :any_skip_relocation, monterey:       "6e83b38345b62debc11a899d6df4e6988955eca6de9bc383b63aaa9b2ba86cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e704b39a0498f3b6014530d08c367fb909aeba07e293d6bbde6bbbb0dd2b6b3"
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
