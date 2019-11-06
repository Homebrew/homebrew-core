class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      :tag      => "v1.2.0",
      :revision => "2a579ecd66dfaf9ee21bbc860fcde8e4d1d12301"
  head "https://github.com/openshift/source-to-image.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7865eec2bd488c5b09844e7c13244e9d19912f75f04f13dbda6b0b393077703b" => :catalina
    sha256 "102e5173cec0a766173a5cafcf95ab35129c2906bfedad3155ab1fe78933ef2a" => :mojave
    sha256 "33822b820f7febe068dc2dfd1fafd5502c18e0aadc9b4b2e91b9f095c6febbfe" => :high_sierra
  end

  depends_on "go" => :build

  def install
    # Upstream issue from 28 Feb 2018 "Go 1.10 failure due to version comparison bug"
    # See https://github.com/openshift/source-to-image/issues/851
    inreplace "hack/common.sh", "go1.4", "go1.0"

    system "hack/build-go.sh"
    bin.install "_output/local/bin/darwin/amd64/s2i"
  end

  test do
    system "#{bin}/s2i", "create", "testimage", testpath
    assert_predicate testpath/"Dockerfile", :exist?, "s2i did not create the files."
  end
end
