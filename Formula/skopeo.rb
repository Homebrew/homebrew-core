class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v0.1.38.tar.gz"
  sha256 "104ceb9c582dc5c3a49dd1752c4c326bba03f2f801596f089372e831f48ed705"

  bottle do
    cellar :any
    sha256 "5211bd47806c18d992f612cce09dc8ac656af6736893144bd6c48c4ede00a989" => :mojave
    sha256 "e236f824cbcb8f80033535aa3fc29ac3f3430d4cccd1c2b7343780abc6636daf" => :high_sierra
    sha256 "7e84ae32ef6ea92ab7e09d4aeeed6f6425ade7f8e509c9a972dca3c37ff91ca8" => :sierra
  end

  depends_on "go" => :build
  depends_on "gpgme"

  def install
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
