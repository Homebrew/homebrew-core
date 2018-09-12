class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/projectatomic/skopeo"
  url "https://github.com/projectatomic/skopeo/archive/v0.1.31.tar.gz"
  sha256 "f41121044ddca07afa63788302caf3582a653269c9601f7528003693d9807726"

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
