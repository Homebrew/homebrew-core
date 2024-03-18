class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.55.18.tar.gz"
  sha256 "3518c25f19a11e8e47cd3dc7a4832ad24a7dbda4f6e44436e66b515460746138"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2021e62a4151647152ea15ca062d1893c0caae4bffeee11256c28ba639a49e87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9f32a84ae96242daa74b41b8e4fa50a9276fc1406a7cf1500c77c88acb784c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d1f3a2ca85a72e953ceaa5f351a123457655067b6e2059151523471b845dba0"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fe32d772acfab99d010544d7aea5fbaef46812d2f5f3df128d7e8f4d22bffd0"
    sha256 cellar: :any_skip_relocation, ventura:        "1b7da9f65a81a3d87dc6d8c94f6c6e862e4ca16fd22e873631768a5c42d0668b"
    sha256 cellar: :any_skip_relocation, monterey:       "48b8e61075783c52411e57cc2876c0802ec94303fb385c947e0c9d6cb99d48e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e519af7870a150cc9a921e83734b11d30e0af93da6b3273553f3a430dd0d2f4"
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
