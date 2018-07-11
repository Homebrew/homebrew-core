class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/projectatomic/skopeo"
  url "https://github.com/projectatomic/skopeo/archive/v0.1.30.tar.gz"
  sha256 "56b4e1f77af3ef7245b3d62e080b165f0e330486765e8f3ea598d5a09fe213ae"

  depends_on "go" => :build
  depends_on "gpgme"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/projectatomic/skopeo").install buildpath.children
    cd "src/github.com/projectatomic/skopeo" do
      system "make", "binary-local"
      bin.install "skopeo"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skopeo --version")
    cmd = "#{bin}/skopeo --override-os linux inspect docker://busybox"
    output = shell_output("#{cmd}")
    assert_match "docker.io/library/busybox", output
  end
end
