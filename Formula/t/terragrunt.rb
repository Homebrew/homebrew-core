class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.58.15.tar.gz"
  sha256 "79066f19932eb850e3f84e0c4c6fdb0eae6827d76a03fb99579b0a48682b27f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf89584ac32c0489132a2e5f23e2e2dcbb011ce13a8970e7daf72eb6f287b1e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72ba785a6edc77987c07d72a5a7be5d48941363aeb273b7f8ebc52569bd88df6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c03df46c637daca0de903c1f6b5d9061b642406621cf22988b3b4e34ef005b76"
    sha256 cellar: :any_skip_relocation, sonoma:         "55c7c5aeeb6812bed16bcdb3c620c80d3a83e2a9b73679532727b7953951f855"
    sha256 cellar: :any_skip_relocation, ventura:        "f60beecd5bbc0bddf914fbb34a46695f53c0be8561c5f671a7f46f25a78ba97f"
    sha256 cellar: :any_skip_relocation, monterey:       "a516c94e0b8c8b8132940d800d90c9416cebe8baf798346ade801c7d5a641acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9eebd65c148a2239acf51a624aaa5f0d7abe48fbffc964a56e809e65f1f6a36"
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
