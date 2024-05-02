class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.62/snapd_2.62.vendor.tar.xz"
  version "2.62"
  sha256 "e4bcf0d7677afdcb7256958fd382a5aad71db13474c08e5828e913614ee88ea8"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eceb214834be9f75683da7ea7af606f7f34aa7ef05fd2c1903929ae1b61ddb8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "388d60e54c9216d7f4973b3236f6f19a931bc27173aac020fc1e2f3da777d41b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d377be715b6b116a73815d171b81f83cbff07d33c426c71cb80b8062acb7550f"
    sha256 cellar: :any_skip_relocation, sonoma:         "518b1b2b0bfdcd3bc7c2a42f70400184d30826045e7a6d3c98a943ba9001a182"
    sha256 cellar: :any_skip_relocation, ventura:        "579405e46ea902adc0f81189412095366d1a8d1268477dfe6dabebd29eb7f3e1"
    sha256 cellar: :any_skip_relocation, monterey:       "666363c4207b3618ab8e7fca7f9c5c4bcb053ac2b4db2f56262a827c7f18e2be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cc5284386a1b55bc542fb0487c9f9ebfd03bfbf12cca5214d3d8ed4bf1579b4"
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
