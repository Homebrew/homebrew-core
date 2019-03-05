class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v0.1.35.tar.gz"
  sha256 "0d7024c09d7b1822acb174912f5b06950a023ef5d05d6b8b442e563c512b4c4a"

  bottle do
    cellar :any
    sha256 "e53a71091b73c48f685331b9595217abdbbd2f4d5d54fa5348f6c43e6db3e39d" => :mojave
    sha256 "9ee8c072fd5d1829f6d8ba3e57af1a10eb534e8703076a6de0f554182a97de5b" => :high_sierra
    sha256 "6e58490a7c81ccb13e1b6c506aa90b21b02d81748228d607cbff8496c32c6460" => :sierra
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
