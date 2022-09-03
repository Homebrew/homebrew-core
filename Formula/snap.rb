class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.57.2/snapd_2.57.2.vendor.tar.xz"
  version "2.57.2"
  sha256 "e4097e1eb8b4845cdebdc08d3861c63a7154b0494fad96569cf7847c6088b2ec"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aaa0d0cd5ff19f1241e566cb8f699f162d0ed11949f9c1b4da55fce708da46e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7cbaec7698fa9d99bcfbe2f4ecc15d39a92c63273a6a797a9a57dc3f73e31f8"
    sha256 cellar: :any_skip_relocation, monterey:       "94146e3f5e4af2d6fcd02b567ff1ec88caec622876c2b6c65c03fc2a15db4aa4"
    sha256 cellar: :any_skip_relocation, big_sur:        "73d995f0ccafbbd84c430e27e45180198a019583f37cd67d9adfe19e00a25c05"
    sha256 cellar: :any_skip_relocation, catalina:       "fbf1b47a9a9114c306bcc64f896288512e356ce3702578c54904fc2883155d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7522c9b4f2bdd6be38c03fd485e17208ae8c563268933f5a155f3350a794653"
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
