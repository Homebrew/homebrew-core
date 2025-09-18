class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "4020825b5618686287d7040a5d992c9e36f4435031219c048cff25213932fa5d"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f86ec84ac66c0984579ca716c7a7b5b32aa8dfe6afcfa67f3ec24fe733ab938"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "247825cbffb910ffc07e8ec49e72e101acf2f8624d432ccf3869bb98874ed1a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "247825cbffb910ffc07e8ec49e72e101acf2f8624d432ccf3869bb98874ed1a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "247825cbffb910ffc07e8ec49e72e101acf2f8624d432ccf3869bb98874ed1a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cf43eba7b409ae0090035d99a4f0d4bf1503449a388bbc888441a055d781c61"
    sha256 cellar: :any_skip_relocation, ventura:       "5cf43eba7b409ae0090035d99a4f0d4bf1503449a388bbc888441a055d781c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b21bc43bc4e0576aca32458bbf76c1c33a9d2f996bf652d1f191d71c9f16998"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"provider.tf").write <<~HCL
      provider "aws" {
        version = "2.39.0"
      }
    HCL

    system bin/"tfupdate", "provider", "aws", "-v", "2.40.0", testpath/"provider.tf"
    assert_match "2.40.0", File.read(testpath/"provider.tf")

    assert_match version.to_s, shell_output("#{bin}/tfupdate --version")
  end
end
