class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
    :tag => "v1.1.5",
    :revision => "4dd77215907d810f8fbc9c23dd8c7454f89131eb"
  head "https://github.com/openshift/source-to-image.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f22e94321d031311c623ede1d7c8e3640acaab99be7d66fc49232d72a2c00a1" => :sierra
    sha256 "353cf7243ea461e34f10a56c08b8e8b098221c6224bef06527db79c8637789f5" => :el_capitan
    sha256 "8349c19b4d5c583a06736d47f4f00e6f4ed3eecc2aa6de5573699a04a1bcb272" => :yosemite
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
