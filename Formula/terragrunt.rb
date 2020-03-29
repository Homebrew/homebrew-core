class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.23.3",
    :revision => "530f36e32e15889807835a33504ef8288c961241"

  bottle do
    cellar :any_skip_relocation
    sha256 "a29313b931f7218f64562ecc2c1c31afcc99d8f34ee30e69654b5e721d3676b6" => :catalina
    sha256 "9852c0d378bd2a71e20c0c86dd84a9c1ad121cd9917bc555145248260e2a9a8e" => :mojave
    sha256 "c09a3c8827b00bd9e4ebc4e98c3078446e258a77b4c11529492f383ad02aa577" => :high_sierra
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
