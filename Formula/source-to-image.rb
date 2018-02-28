class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
    :tag => "v1.1.9",
    :revision => "f303aa0a25c62e39140b8df130db86debf2064d0"
  head "https://github.com/openshift/source-to-image.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "75642041c5a1a26037aa448e506c34519ca00893b382e4db1af8ea4f7881d88e" => :high_sierra
    sha256 "333b16c0d7d34ece5cb55eea19f8d4567d0ccf0f0cbf3fc2611974e501e035e5" => :sierra
    sha256 "01ad9a176bec93cbfe0f9c9dd14a477f8670b2610641e78ff97b92230f56a6be" => :el_capitan
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
