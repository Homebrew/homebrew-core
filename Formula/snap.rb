class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.46/snapd_2.46.vendor.tar.xz"
  version "2.46"
  sha256 "c4f532018ca9d2a5f87a95909b3674f8e299e97ba5cb5575895bcdd29be23db3"
  license "GPL-3.0-only"

  depends_on "go" => :build
  depends_on "squashfs"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/snapcore/snapd").install buildpath.children

    cd "src/github.com/snapcore/snapd" do
      system "./mkversion.sh", version
      system "go", "build", *std_go_args, "./cmd/snap"

      bash_completion.install "data/completion/bash/snap"
      zsh_completion.install "data/completion/zsh/_snap"

      (man8/"snap.8").write Utils.safe_popen_read("#{bin}/snap", "help", "--man")
    end
  end

  test do
    (testpath/"pkg/meta").mkpath
    (testpath/"pkg/meta/snap.yaml").write <<~EOS
      name: test-snap
      version: 1.0.0
      summary: simple summary
      description: short description
    EOS
    system "#{bin}/snap", "pack", "pkg"
    system "#{bin}/snap", "version"
  end
end
