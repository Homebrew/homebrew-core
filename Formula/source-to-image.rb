class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      tag:      "v1.3.1",
      revision: "a5a771479f73be6be4207aadc730351e515aedfb"
  license "Apache-2.0"
  head "https://github.com/openshift/source-to-image.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "885c70eb74a6c0faf5cebdf1468820a26ce8ac08a555821c3d419c7725e09256" => :big_sur
    sha256 "3fbf3469cf68fa605bbac9b3cb726ffc5c1f485d27dcacd4b9310e24e8d165e4" => :catalina
    sha256 "c576266fcc9e09cfae7ea91d9bc6f76b4aad025d087cf11acfe94218cdfe1774" => :mojave
    sha256 "29fb2fc7a031e904e743264878f9a4010e7c5d6aa0a3091ea0ec1038f312a5ca" => :high_sierra
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
