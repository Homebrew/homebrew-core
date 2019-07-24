class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.19.11.tar.gz"
  sha256 "8b87fb836720be885ef806092c750db7d9a2d73d7de97631c4b8c97b64390029"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "68d9c8e3e367fea3d9a7127aee7c1f3a373bfb4cffad756dec21daf70e1663cd" => :mojave
    sha256 "0bdf099b7d2866690d3547f316128b3156fc1a2f2f11fbf0a26306d7d7787f4f" => :high_sierra
    sha256 "99184c1cece069a2f7e736ccbd50b6e745fc5c135e5a22cdd364a814bb657208" => :sierra
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
