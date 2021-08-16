class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.31.4.tar.gz"
  sha256 "8d1cbdaf4f6a985cc9a2bd98dee50823bd102286e604022f7746ca0bb27f0e21"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bdf1bd112da37a86f9815d7dc8f8ce203fff851d9e61e49389e050852178b641"
    sha256 cellar: :any_skip_relocation, big_sur:       "8f1d46f03a479023a449f4fba89c75234798fcc12ee295314467c815ea68a192"
    sha256 cellar: :any_skip_relocation, catalina:      "3dc4339eaa97177ce53c3788f75c894b08cbdd7fb1c71308235f463c112bd75e"
    sha256 cellar: :any_skip_relocation, mojave:        "39c9b0d0fd7b17685b899aa8f0087e1191fc7464ae82c22d74e28f49eb3488fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb21c8f8fa5b3a1c30efd26f7dd9a68caf58e9b464a72c580a407da5095ada8e"
  end

  depends_on "go" => :build
  depends_on "terraform"

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
