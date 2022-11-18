class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.57.5/snapd_2.57.5.vendor.tar.xz"
  version "2.57.5"
  sha256 "22873493d9cd389b7d33775f3af22d663a749ecf53c4b93c03fd880350ee612d"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecc7e1d7f0f674aa91c3c61da4f94eb65620c0afb5dbdaac280200dccced4b0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "936cac46a02ef15b778333f62aebea84f574a6a15bd8a3d79798b96e75068399"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4ce43f7314e73f1cb46bf34f9d13501dbbed0a0de7bd80137c1f4b0d29c8e98"
    sha256 cellar: :any_skip_relocation, ventura:        "09ed297da017261e8a656a9c038dde86945ae139515d73dd3dad256fe88d11a7"
    sha256 cellar: :any_skip_relocation, monterey:       "8f69ee661309d0f874accb20495f13191b0b086db9a20512251ca228c7d6b0b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "894e9d02f380268436288dacfca55d27bd456adad3f8cfb3b02969ce918f87d0"
    sha256 cellar: :any_skip_relocation, catalina:       "2b4904282035341962ae8bd5a719e381ec5c28a65c258d35707e9cf67a23c6d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4edb04e4df53a253084398de00e75940702f3f555e7dbcbf5c6bad407c92788f"
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
