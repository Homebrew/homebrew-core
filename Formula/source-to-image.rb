class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
    :tag => "v1.1.7",
    :revision => "226afa1319c3498f47b974ec8ceb36526341a19c"
  head "https://github.com/openshift/source-to-image.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e10011c82ad76775bb109c7d2465a11607637f0fe77aee092420b665bf684e8b" => :sierra
    sha256 "02ce3c485ad0a6ff25b6e1a1eb036be38d30c327862d444433a675cd0fe020a9" => :el_capitan
    sha256 "7684f7305b38488d608200c4329686b9dff69a35e2c8a37718bc98b60e85d426" => :yosemite
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
