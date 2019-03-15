class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.18.1.tar.gz"
  sha256 "84360062d59acad5319f1bedf910c9ef487b401cc25469723599c0bb15932e58"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5965bfdb5e3ecbd2bf2c3a67bb920f6bb171ab098ed54604c3c13e858223238c" => :mojave
    sha256 "1c8567b0bdfb4bf13068e2dee19a38e14153b36ab56b7edad0fdb3c65a8cc5af" => :high_sierra
    sha256 "62f565e1f750753695a37863683c8888a41966e6553af5d742f273bf20178eec" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "terraform"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gruntwork-io/terragrunt").install buildpath.children
    cd "src/github.com/gruntwork-io/terragrunt" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=v#{version}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
