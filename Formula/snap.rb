class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.58.3/snapd_2.58.3.vendor.tar.xz"
  version "2.58.3"
  sha256 "7b8319b5ce1c2957651d0fec8c935bfbee02a1340927d9055ac1bdfdb9c1fca5"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db5c4acd64fc1f2e567c5b27d6cd78e74d38d7941520da8b36eced66023cdbb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ce5b214a71a01552901ef4ba646d084f36cde69018db9cfa0f31b627c616343"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72e3199e1a6b7dc1af18540c7bad41e5deb77b56337b50fb1e4574d346ed86fa"
    sha256 cellar: :any_skip_relocation, ventura:        "17a23b17e6d280797e93e9dd4db85192220863b0d9d2ed554a2a280aad3b2d34"
    sha256 cellar: :any_skip_relocation, monterey:       "e7288a2071c94bad1eef8df1562166bf3c6850565e21a6dac26692a98db11624"
    sha256 cellar: :any_skip_relocation, big_sur:        "e21dd08f254fc4eed05c806ee2ed5869bb8aadbe990ac5e74a192718da178afe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07ae46a5208b9dfdc352d634c86e9916a8811eebf176e024faeb057347a041c3"
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
