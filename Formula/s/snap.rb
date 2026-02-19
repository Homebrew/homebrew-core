class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/canonical/snapd/releases/download/2.74/snapd_2.74.vendor.tar.xz"
  version "2.74"
  sha256 "ed034744915fe538b3b67d9bcaf4d28cf5fe8bf75914da4a887ae393d9931ebc"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f905965dd405869a706436d4038861fb5a3f23b2fb9f464f05681cc7611ee5cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f905965dd405869a706436d4038861fb5a3f23b2fb9f464f05681cc7611ee5cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f905965dd405869a706436d4038861fb5a3f23b2fb9f464f05681cc7611ee5cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9e5421ab243c0e9a2faf228747bf1d276be417280221b6da0c6e20bea55f9e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0d28a7a1309e5132622b544054255c34f0ed2aafb02fba5a999c618053599be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "723c3c00d4cdd7d1fd765a0f1f954523ab2dd50c69e25a76d5575ebe16d51691"
  end

  depends_on "go" => :build
  depends_on "squashfs"

  def install
    system "./mkversion.sh", version.to_s
    tags = OS.mac? ? "nosecboot" : ""
    system "go", "build", *std_go_args(ldflags: "-s -w", tags:), "./cmd/snap"

    bash_completion.install "data/completion/bash/snap"
    zsh_completion.install "data/completion/zsh/_snap"

    (man8/"snap.8").write Utils.safe_popen_read(bin/"snap", "help", "--man")
  end

  test do
    (testpath/"pkg/meta").mkpath
    (testpath/"pkg/meta/snap.yaml").write <<~YAML
      name: test-snap
      version: 1.0.0
      summary: simple summary
      description: short description
    YAML
    system bin/"snap", "pack", "pkg"
    system bin/"snap", "version"
  end
end
