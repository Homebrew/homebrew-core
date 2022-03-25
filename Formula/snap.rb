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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d6c82fed2961b33bfae3f1269f4d35da6d5082735203ef0c9964164db53c7fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f82d3c3eae930ade1ba951e693559c00eea90daf6d44c1f1c5fb6490adb1720a"
    sha256 cellar: :any_skip_relocation, monterey:       "d113cce3047c2210dc092e551e4853fc4147a17136809ca1194b73acb5cddb13"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b128428f69534aa1a1a0357c616b469139355cbd7fe6f6640570e09c5fb6569"
    sha256 cellar: :any_skip_relocation, catalina:       "befcd2a8290ade786979dd3911e4857de96c36df99fb55150c1513252d858b4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce3f48bd0a0ae32b1a88e6008ff62d3a9a4e9356875e16107e6fa04a2cf1c35e"
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
