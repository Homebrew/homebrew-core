class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.23.0",
    :revision => "434d75898cddfad9caf258e739919e4a6947f8e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b61352b7cd7240b4a96b0172cd2d3a87bdadcffa63a595b07fdc6dd4b892a7d" => :catalina
    sha256 "ec57330e1cc7f085ac1cd5d4e9a6d4377501f49b2aa760a0dda02b620c9bb30f" => :mojave
    sha256 "7a52349bc0b6a96501260cbd3b39bb729e11e8707a4954507941e3440d257c82" => :high_sierra
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
