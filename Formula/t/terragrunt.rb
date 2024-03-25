class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.55.20.tar.gz"
  sha256 "8ac07bd48e3dbe566b360a05359ab943eb161cf48dc2199206a95093e85bb7fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "996360319e5fd353d2a43f27ea2ebe771056eed564e59c4f08fe105c7860472f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60b3082372665642d77fdd67beb0c388deb9fafdc7699d3f76a6c5fb67c701ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01abd72494cd2d7c88a44fc69cde3898e8b5d564231a228c61211f0c5e9a4526"
    sha256 cellar: :any_skip_relocation, sonoma:         "4223cedb4a2e5eb80b04020638da75018d647f250a01cca75e36b82d3a255be2"
    sha256 cellar: :any_skip_relocation, ventura:        "a6d0328f07ca35a77f73d87f68d97674197242a6d59ce0a4bdd234f7121b6990"
    sha256 cellar: :any_skip_relocation, monterey:       "a6b32713adfb47b7460b58f0c75d7185790cdc1404234437358dc29a6151b215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92bbf4c8df03835c0a425befa3bba54e64e1e75dc4406bbec185e1fcc251a32b"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
