class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.56/snapd_2.56.vendor.tar.xz"
  version "2.56"
  sha256 "33f4d7421dfe6a19cefb9b937d8d64599a1d079c6bf2214b146c148ff6fe2fff"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82857be5a05daaa1dc46e17cd07e186b8b0ab88795eb7c9423fc85ce44c827b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abc27dd70eb85501fcf11621250f39340e2bd9f694f7fdf0f95f0417766486f1"
    sha256 cellar: :any_skip_relocation, monterey:       "b125d25363b81ad9df6c3b3dfdfbfc1ad3518e885ad5666f97bcea8bd3740387"
    sha256 cellar: :any_skip_relocation, big_sur:        "34f25541b76f6cb566a662cd4ff7148475188c05f82b4d5fd053130a2b258343"
    sha256 cellar: :any_skip_relocation, catalina:       "5efca3ea97ce638085408426901cceb6339e68cc0c720d59cfb4783c7f5b3aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ad880a8e3bf5bcb830a90fb45044b84a907fa8a7f7e1f8cd30aafbcd7b99abf"
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
