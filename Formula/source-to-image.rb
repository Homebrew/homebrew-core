class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      :tag      => "v1.1.12",
      :revision => "2a783420bb648df7bdd7e1fbf99b8e53bbe4e415"
  head "https://github.com/openshift/source-to-image.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f66686a0a306a83ee579f533890c1e165833045f6b2d64b17ba7b21663404686" => :mojave
    sha256 "ebaf4a14dbd202fe626ca18b58ef34d2d4e37ce282b0607dfe1c9cc7417431bd" => :high_sierra
    sha256 "89a37daba6a14df3ae72f9872ec8a48ffd73939d3389ca47926cfe923810b0a4" => :sierra
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
