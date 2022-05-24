require "language/go"

class Sift < Formula
  desc "Fast and powerful open source alternative to grep"
  homepage "https://sift-tool.org"
  url "https://github.com/svent/sift/archive/v0.9.0.tar.gz"
  sha256 "bbbd5c472c36b78896cd7ae673749d3943621a6d5523d47973ed2fc6800ae4c8"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c93899f610215c5f879a7dc895c6d549573bde6389ecd1b5624bf119e585d7a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28fd605e32b0dbf9526939fd5e366c46f5ad0c45b2a5e9cb2bb7fb8815a7f97c"
    sha256 cellar: :any_skip_relocation, monterey:       "eaa4c4e84606b8dd32e3064819fc05f16b22a76f0be493bc283a2d256c050ff8"
    sha256 cellar: :any_skip_relocation, big_sur:        "08978d211e26b262c551418ca7c6d93f2b05a0e7887e10831a5a70f23f445e8f"
    sha256 cellar: :any_skip_relocation, catalina:       "d2c0f8e64a32bcbaa45976a350d302dd13e3b68595162d69005dae7599d9be40"
    sha256 cellar: :any_skip_relocation, mojave:         "08aae3031f30b5502bd93b26c4a2e655077f3a91c212b04898c19d14444ec0e6"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b0d584ae926816c4f525c9070cb67c7622e851c3cbba67e7c0b9cae5d30feb00"
    sha256 cellar: :any_skip_relocation, sierra:         "42fbf76075951fd28a27b4e2763b3af58eb93b0260c3a3c82719d7a32ef7baec"
    sha256 cellar: :any_skip_relocation, el_capitan:     "6ee1bdf8b60fe3c3528a4a2698f19518a7bf71838ceba58ab9a199a6624f3dba"
    sha256 cellar: :any_skip_relocation, yosemite:       "170f9861eb8843932556284268f1a00e3e0a0c455e35b55c11e44c5b325ced85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d9feea7d6e51c11b1a56043ed9b15731dac5440dd4eb492c1468ef0497a1af9"
  end

  depends_on "go" => :build

  go_resource "github.com/svent/go-flags" do
    url "https://github.com/svent/go-flags.git",
        revision: "4bcbad344f0318adaf7aabc16929701459009aa3"
  end

  go_resource "github.com/svent/go-nbreader" do
    url "https://github.com/svent/go-nbreader.git",
        revision: "7cef48da76dca6a496faa7fe63e39ed665cbd219"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        revision: "3c0d69f1777220f1a1d2ec373cb94a282f03eb42"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

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
