class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "7f118d26885e32b5b1bcac477426437525405ef1f89a5164ff2c646da6f5f1ad"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ad947166ddc07f1a1199cb2b5e132e15b0fc20c802f23ebda399c01d7ba5129f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bcc8a2c59fef1a74eef87ea859df9f70c963e9b10a1781bc7c937579e7280155"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3acd595d6fcaac1619d7d2fd7ee07dcc18b1e53262af0e186484bb5eef8cb1fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ebf5cb8df8456456896bd581776c1543aa6b49697a0b6e07e9f9e3ef0f816e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "62588731be0bd37120b14168ed3e345c3d2fdbaa1a71d57489ad1c60f145cd97"
    sha256 cellar: :any_skip_relocation, ventura:        "98a4c0e490801db1415de507a10140c85f0e4543d9d0651b827608b3fc25be0c"
    sha256 cellar: :any_skip_relocation, monterey:       "4da185a6ee55f78e281677558eaab1ebe05d2e615c4c72023d4ad924ad113da5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23d034a9be35da9cc453837166f3ffcc5b667e370555a05c9585b2f46869acfb"
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
