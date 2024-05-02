class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.58.1.tar.gz"
  sha256 "1ce7d68439c2b19550417890c04911fb10f1a7dddeb82947f485ebf198c86dc5"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e280b8d820837d5e90f9e1a0a8516e988d351b392821b12df6cc368860b9cd52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d85d4d39c02128df334539057b8ea2349c9da4e667f50ec7fdd79fdb6684b426"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e6445371580a02354fca794c6ac887ebc7d9af964e61df5dc5bcc3bb5f0a46e"
    sha256 cellar: :any_skip_relocation, sonoma:         "36f9b71d3384611cf51fb341298b19a2b2b8b252ff7c1ac3c8d1aa859ae42b32"
    sha256 cellar: :any_skip_relocation, ventura:        "85d9195d8d32f81ec06d29d3af1cb81176ea5d3fa7e875802d9af7a682ce3435"
    sha256 cellar: :any_skip_relocation, monterey:       "8a43385effd2907b35bfdfb53105b4b1dd826e7ad241543908c927252301e95f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fadba36c3a9055b7dc10874ee8643197a100014503ce59c843e8c4eced29c830"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
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
