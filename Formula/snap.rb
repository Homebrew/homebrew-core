class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.59.1/snapd_2.59.1.vendor.tar.xz"
  version "2.59.1"
  sha256 "67d24dd43e963007443d287ee8517cc8c1ab6c8d8a2431564e81e79a5f454ae0"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87adcb3842b2e2b1d0376f81e6fb829ef696c39cc58e18bc9223dc83f5a2bf46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87adcb3842b2e2b1d0376f81e6fb829ef696c39cc58e18bc9223dc83f5a2bf46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87adcb3842b2e2b1d0376f81e6fb829ef696c39cc58e18bc9223dc83f5a2bf46"
    sha256 cellar: :any_skip_relocation, ventura:        "1508e4c2c22c7cbc348334746cb49a2970b15625100ed9906b45656d7f42a6eb"
    sha256 cellar: :any_skip_relocation, monterey:       "1508e4c2c22c7cbc348334746cb49a2970b15625100ed9906b45656d7f42a6eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "1508e4c2c22c7cbc348334746cb49a2970b15625100ed9906b45656d7f42a6eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef66215f1ffcc35bbbb836841013fd718489beade3f8428eda8a57388a26725c"
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
