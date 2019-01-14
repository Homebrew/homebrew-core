class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      :tag      => "v1.1.13",
      :revision => "b54d75d3de92d123e68a79c6ee09c2c5fe44e720"
  head "https://github.com/openshift/source-to-image.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "af4411e7f5e5778eea3c2bd2a14ba87b750368073dd5b9ae8b96dcf5fa8518bd" => :mojave
    sha256 "8d4cc648d5ae922ffde63f5a0d019e5324e289bde4db4ddbae99419d695acf4f" => :high_sierra
    sha256 "c8cb66a64bf537e985d1b32bea711be099b5377002d5ca86c59c34cb6b39368f" => :sierra
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
