class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.40.0.tar.gz"
  sha256 "f3117d0a3afc10508bfc69844ef3361f68d8a8122b175e01cf873ddaae036ce9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1fd4fd1eee548ab4ef54fc8cb5ed05354646e39ae7ee7ccf7abb989337a6e82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bae112ab303dec7beb888330d9afeefdd0ec3a539f5f4c240e8689ed5c0f8c44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7c8936bb71ef4d5d9e8bc5d862a385898dd130a99955324605a6c5e703a2fc1"
    sha256 cellar: :any_skip_relocation, monterey:       "6088a41f92963349ae0a9caae6e5f25ee7d66c51cc46313459b5daeaafca0000"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5fd927f32447be2f2ebe5adcfbd5e34f9fd8caed2cb3be6649f989a6bc0f36f"
    sha256 cellar: :any_skip_relocation, catalina:       "98ac1c7f1513f0dfc0572746c5b1563747d9999df0c57e71dabfeae7034ec253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cad6b598f10cd90f0c7762486c797067c2b652f0d97b08794fa82b5798d87ba1"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
