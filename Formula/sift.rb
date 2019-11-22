require "language/go"

class Sift < Formula
  desc "Fast and powerful open source alternative to grep"
  homepage "https://sift-tool.org"
  url "https://github.com/svent/sift/archive/v0.9.0.tar.gz"
  sha256 "bbbd5c472c36b78896cd7ae673749d3943621a6d5523d47973ed2fc6800ae4c8"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2c0f8e64a32bcbaa45976a350d302dd13e3b68595162d69005dae7599d9be40" => :catalina
    sha256 "08aae3031f30b5502bd93b26c4a2e655077f3a91c212b04898c19d14444ec0e6" => :mojave
    sha256 "b0d584ae926816c4f525c9070cb67c7622e851c3cbba67e7c0b9cae5d30feb00" => :high_sierra
    sha256 "42fbf76075951fd28a27b4e2763b3af58eb93b0260c3a3c82719d7a32ef7baec" => :sierra
    sha256 "6ee1bdf8b60fe3c3528a4a2698f19518a7bf71838ceba58ab9a199a6624f3dba" => :el_capitan
    sha256 "170f9861eb8843932556284268f1a00e3e0a0c455e35b55c11e44c5b325ced85" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/svent/go-flags" do
    url "https://github.com/svent/go-flags.git",
        :revision => "4bcbad344f0318adaf7aabc16929701459009aa3"
  end

  go_resource "github.com/svent/go-nbreader" do
    url "https://github.com/svent/go-nbreader.git",
        :revision => "7cef48da76dca6a496faa7fe63e39ed665cbd219"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "3c0d69f1777220f1a1d2ec373cb94a282f03eb42"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/svent/sift").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"
    cd "src/github.com/svent/sift" do
      system "go", "build", "-o", bin/"sift"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"test.txt").write("where is foo\n")
    assert_match "where is foo", shell_output("#{bin}/sift foo #{testpath}")
  end
end
