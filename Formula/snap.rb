class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.57/snapd_2.57.vendor.tar.xz"
  version "2.57"
  sha256 "b0e7df310dc434a1023846a62cf2c6338f24b9a7a9101189d1d04ae148029919"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "912707ad5063f1c70cedd78451815942f967a0caaaf2ae638fcd52ab9b2995de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99d6f025a865a7cb0ed447b035a0bfa58ce9cb7d9988a5313121e555885ad883"
    sha256 cellar: :any_skip_relocation, monterey:       "453c2fa1fa9f73871fd7cb965bb7440bec236ebc059cafaa6cbb57b5bf8b65f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "01086695c74b5e7a46bda4586efe02c81bc0bfcc41d8e072339bdedc0000c9c8"
    sha256 cellar: :any_skip_relocation, catalina:       "c90c029804c7b2852b7f7535f3a9344ecb66b84a9c7c2fe9107a0db608b97f8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc12103667e96ebff8d1fbd6762c31ac587ae547e97b8f6817cd9105b4a92179"
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
