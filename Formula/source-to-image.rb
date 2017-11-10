class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
    :tag => "v1.1.8",
    :revision => "e3140d019517368c7c3f72476f9cae7a8b1269d0"
  head "https://github.com/openshift/source-to-image.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "df0920e395ce8aff9fc02e0acb214e5f230d0dc407c0439ca1bb16dc2b5d59e9" => :high_sierra
    sha256 "483a0cee5e489f2c3ce9fedae2c867cb63b7e3990635100fb936c5361e1cff08" => :sierra
    sha256 "6d363d34e070f80cf79bded69bf6a8f71932a94d36f6a7062e504b83924f47f0" => :el_capitan
  end

  depends_on "go" => :build

  def install
    system "hack/build-go.sh"
    bin.install "_output/local/bin/darwin/amd64/s2i"
  end

  test do
    system "#{bin}/s2i", "create", "testimage", testpath
    assert_predicate testpath/"Dockerfile", :exist?, "s2i did not create the files."
  end
end
