class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.55.3/snapd_2.55.3.vendor.tar.xz"
  version "2.55.3"
  sha256 "1b50db46166465dfe64af305756a699f766d17fd95ecb0f93872c55edbbe3912"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fc83335dad921f14cd2494e8b9962ed454a719071cd795083445d9024014dbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe1a3c7a6fabf723c73e02d36944587b95886a23a3ad663718dceed8caa6f59c"
    sha256 cellar: :any_skip_relocation, monterey:       "bbd9d1a822c7f568b3868c4ae2fc15f0b57ace1704ef3f30f9c815931fbd1750"
    sha256 cellar: :any_skip_relocation, big_sur:        "30dae319e599d99893f71f61b5f81582db88fccedc1f5f4ad407f2e2f437ce2d"
    sha256 cellar: :any_skip_relocation, catalina:       "db0421d48031735ad98b9cada21231d8c8d2aaa1c525e481430fa58f0121b5a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fe514d09a59b455acbb84a37c234a41b7c63712aff9d8a8c9122fb3b40702e1"
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
