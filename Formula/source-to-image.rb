class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
    :tag => "v1.1.9a",
    :revision => "40ad911db82b8720f9956e8aa76371a8f185a6de"
  version "1.1.9a"
  head "https://github.com/openshift/source-to-image.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2bbf475e6ce03ad31a67e85a9058b071d52df49ac878afaafa073629764cf838" => :high_sierra
    sha256 "1e7142bddd6ca1dc988ebdd20ae35bf927d6169d5390eb67bc183c585cef6391" => :sierra
    sha256 "d000c952d0decf6ce5c8adee1b549bd268e47bb7b7e665f2e91c4b97789f6e84" => :el_capitan
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
