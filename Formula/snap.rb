class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.60/snapd_2.60.vendor.tar.xz"
  version "2.60"
  sha256 "1d940ba7cee1b6a1fd961c591abf8fdde9d313eff0fb8b6967ad01f40426f33e"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a19802b56f6812b3f556812dcb01d70600616c33b22440912e142a6874c6703a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a19802b56f6812b3f556812dcb01d70600616c33b22440912e142a6874c6703a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a19802b56f6812b3f556812dcb01d70600616c33b22440912e142a6874c6703a"
    sha256 cellar: :any_skip_relocation, ventura:        "2390e32cc5fa789a412a439cd36428f00722c37aad51ef30f23a999aed2797fc"
    sha256 cellar: :any_skip_relocation, monterey:       "2390e32cc5fa789a412a439cd36428f00722c37aad51ef30f23a999aed2797fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "2390e32cc5fa789a412a439cd36428f00722c37aad51ef30f23a999aed2797fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5fd23f68ad4591ee40cb01855388a91ad316659cee988a4484970647a9f808c"
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
