class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
    :tag => "v1.1.5",
    :revision => "4dd77215907d810f8fbc9c23dd8c7454f89131eb"
  head "https://github.com/openshift/source-to-image.git"

  bottle do
    sha256 "32f2456dba8758ffc4041903b129f38446ef5dc2916c70f1001a94849af77c43" => :sierra
    sha256 "e88c854a0dad4612e469940f0a09566aef5317b0c416eb0dcb09b73349332024" => :el_capitan
    sha256 "785d3a1d1301ef2d59af28cf32648c1de2ee2f8241bc9d65501693222badf8b2" => :yosemite
  end

  depends_on "go" => :build

  def install
    system "hack/build-go.sh"
    bin.install "_output/local/bin/darwin/amd64/s2i"
  end

  test do
    system "#{bin}/s2i", "create", "testimage", testpath
    assert (testpath/"Dockerfile").exist?, "s2i did not create the files."
  end
end
