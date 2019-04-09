class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v0.1.35.tar.gz"
  sha256 "0d7024c09d7b1822acb174912f5b06950a023ef5d05d6b8b442e563c512b4c4a"

  bottle do
    cellar :any
    sha256 "00748b67fb6735685f109bdb030cad7aa51705feaa1c2857072e20ad901d3bc5" => :mojave
    sha256 "c2414a14bdd6b3babf99850eacce1489159a6f07bf389ebbe34e7fb3c0053f45" => :high_sierra
    sha256 "5953c28655fd5a4c51d4ac4616272a8be1f94b206752750460a83bfdc559c0b5" => :sierra
  end

  depends_on "go" => :build
  depends_on "gpgme"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/containers/skopeo").install buildpath.children
    cd "src/github.com/containers/skopeo" do
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
