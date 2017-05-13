class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
    :tag => "v1.1.6",
    :revision => "f51912980d665f1297bfe0d4ae7f871067c963d7"
  head "https://github.com/openshift/source-to-image.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "71a4880319fcdc42d4a5e4883f6bc6df06793ea1a7a654f948757480bd758c9a" => :sierra
    sha256 "3926b5ceef51bbd8f1ed5f3fab153f5e8bc177f6dad3b15191bb18e5e358df88" => :el_capitan
    sha256 "1f485186be20eb7fe3b059cfa974eb49b77eaca92cf1b9fbb93508a9fef554be" => :yosemite
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
