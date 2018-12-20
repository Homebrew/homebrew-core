class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v0.1.33.tar.gz"
  sha256 "04cb5e00805d5203cf4f9eaee22e3f3c0e6f951004b837eea2d7aff0f5897f5a"

  bottle do
    cellar :any
    sha256 "31a91d2d9844abe52912a91b864dab8d6989cb50962120c3661a3d6694dcd46f" => :mojave
    sha256 "42a832c73b1bd148f95994f46ae0f264ef66197a081495ca40c5dbf220543d7d" => :high_sierra
    sha256 "60217d28f054d6a9f617f4fade136d84f686319a1883282253978a5b01798803" => :sierra
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
