class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      :tag => "v1.1.12",
      :revision => "2a783420bb648df7bdd7e1fbf99b8e53bbe4e415"
  head "https://github.com/openshift/source-to-image.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1cc6dc558a2ef92dfa0d4a97dae82fd265702533eb4c3af8fc6f5d5a58d8be3" => :mojave
    sha256 "e3ddba7b7f22fcf501753af1b754170eb9eb48bd984609ba6299808652287e6e" => :high_sierra
    sha256 "45fac1d93d51309bbe1cc2db91b387d027677984542919dfc9181865cae6d19d" => :sierra
    sha256 "e214eb4adb5e5aba7a23e96728f1cb3ca092921693cbbb85582196b9a39f64f4" => :el_capitan
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
