require "language/go"

class Sift < Formula
  desc "Fast and powerful open source alternative to grep"
  homepage "https://sift-tool.org"
  url "https://github.com/svent/sift/archive/v0.9.0.tar.gz"
  sha256 "bbbd5c472c36b78896cd7ae673749d3943621a6d5523d47973ed2fc6800ae4c8"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e96a45216a604a6d6b7cd69857c2b9ff467026ce79c4f64e200c04f36d74e06" => :el_capitan
    sha256 "7becb81421cfa949e0d8c4d9595e730aefe129324d286f9e2a1a1a8eb8d4d26b" => :yosemite
    sha256 "d8985473aca2ec8f7cd519fe49b13937948357ac2f690a014b9bd8e005d0c9cc" => :mavericks
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
