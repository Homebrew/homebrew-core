class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.55.2/snapd_2.55.2.vendor.tar.xz"
  version "2.55.2"
  sha256 "a6db25c1b381f8083578f170789a292cdbe2d45aa2c0fadda77de57692a9b360"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48343a263989ec9530a083544c3b4373ec4b46766009446f3aa5a03308599b05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb3ee5d668951cb01d091e6b8cc6c86581483a4bd1e2257dee37e77bca0972b3"
    sha256 cellar: :any_skip_relocation, monterey:       "7f20a04d6d6ee9265d9b25600aebbe03a0184050a48afde9bbb93d4672a17f34"
    sha256 cellar: :any_skip_relocation, big_sur:        "7989d4872f68cf0a999fbefd0b2eb9be3a948b380bb22041a5a0125d691589cf"
    sha256 cellar: :any_skip_relocation, catalina:       "bb19a6233fc10626d6b736e2a719704b4ada39d1f7c65239588fc7b49de7d053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6fca1b82fbcf2f50b1a67fb98b30dfbef447071cc8f6815c2212cb60f5086e5"
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
