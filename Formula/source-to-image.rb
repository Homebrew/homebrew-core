class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
    :tag => "v1.1.4",
    :revision => "870b2730357b2664598b47672a4840e3ebd31338"
  head "https://github.com/openshift/source-to-image.git"

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
