class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "84a95a2edab16977a1f887bfeac8661b6baf704739d58827062a493cc806f1fd"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4690f147565e062217c0ebbf753d419b109c7068d422943f0183cfeca29bccf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "200ee0490be61b46f6fc8e27e41b9935e3712fb34da9cf8493906e1cdb79fa75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40f755b8f854fbe4cb3899517176a4f5e1f36955c99e147ca51049fd8188354e"
    sha256 cellar: :any_skip_relocation, sonoma:         "d080200e6f98e84075a318a77c71df0de75d8f471f15aee8ffddbe6ea11804b6"
    sha256 cellar: :any_skip_relocation, ventura:        "d2ffe96f61ebb13fda660d4c53031031665fd94b23d66d5adb3fd40877230569"
    sha256 cellar: :any_skip_relocation, monterey:       "e6bd4995aab6cc794b1750076b859e92dd5a3a0ac80098f882f49010e3c33232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77eeafad99cf2359dc72e7d413c91452dc6c72d58d8e1fe1f892af3762b36072"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"provider.tf").write <<~EOS
      provider "aws" {
        version = "2.39.0"
      }
    EOS

    system bin/"tfupdate", "provider", "aws", "-v", "2.40.0", testpath/"provider.tf"
    assert_match "2.40.0", File.read(testpath/"provider.tf")

    assert_match version.to_s, shell_output(bin/"tfupdate --version")
  end
end
