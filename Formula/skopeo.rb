class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v0.1.32.tar.gz"
  sha256 "fcb593d4fa4cb6cf8f1817d21f43a8051c1d8c759b857633d4b932361dbd93a7"

  bottle do
    cellar :any
    sha256 "739b39666fe9f666786402ddf84eb3d2634d4ec499e074dd516e6ac059625445" => :mojave
    sha256 "83902322df72c5135db5f42240530201c8d2d537e726957d0b4b444917a45457" => :high_sierra
    sha256 "82452c5fb8c7e23352f948781561907961cb1eb47448cac478b892eb511969a3" => :sierra
    sha256 "f97bd8ff396fb65dc316df91ab06cb530befca70dbcfeac2ab5be48cc1a3fc92" => :el_capitan
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
