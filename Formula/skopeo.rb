class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/projectatomic/skopeo"
  url "https://github.com/projectatomic/skopeo/archive/v0.1.31.tar.gz"
  sha256 "f41121044ddca07afa63788302caf3582a653269c9601f7528003693d9807726"

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
    cmd = "#{bin}/skopeo --override-os linux inspect docker://busybox"
    output = shell_output(cmd)
    assert_match "docker.io/library/busybox", output
  end
end
