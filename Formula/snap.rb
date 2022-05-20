class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.55.5/snapd_2.55.5.vendor.tar.xz"
  version "2.55.5"
  sha256 "7cea26a599621e440af4b5729468c4c3de7145f8e17a495a7c33935cc89777af"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6234d777816fdb359b6d502e8fd15ee3e8ba2f88340e31c725bf9709e5a051d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e1f8ad12e6d008d002d1f9fc58cd2b10b6e2b641e7a4c90e2fe103bd1f2838e"
    sha256 cellar: :any_skip_relocation, monterey:       "8a4e4c9c31970e44ed2008aa6ea27ae7c37155552bd5e0657508fb3be3fed029"
    sha256 cellar: :any_skip_relocation, big_sur:        "b80177d24ffaad6fbfda4ea8f98ef8713b086228535e28255125243f82adfbbc"
    sha256 cellar: :any_skip_relocation, catalina:       "149e0db58c24de516505494174b050680ab4be74df7b28ae621057128989021e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0cc14d2a29f105ac6933434f2d8ec119f402a66fffd05d88ca467bafb4a6e29"
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
