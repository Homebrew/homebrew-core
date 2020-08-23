class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      tag:      "v1.3.0",
      revision: "eed2850f2187435ef5d83487e05bf3dc18622ceb"
  license "Apache-2.0"
  revision 1
  head "https://github.com/openshift/source-to-image.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1082f391a8b448d93865d97431856b29ca5c2d845686f04c5ae4425dc0ead5c5" => :catalina
    sha256 "db15e9cff473ac13375703f67b00907016001d2888b4a89c6ec065b2dc460d76" => :mojave
    sha256 "3c107497236774e24628577c13c67372d9814967c9a6f97651d8c05935bd8aa0" => :high_sierra
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
