class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.17.3.tar.gz"
  sha256 "5502b87131d642886cfcc5266092f7360b27f4f3f21b6dbb1f3ac2996dcd7da5"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "82d39761f85e49c8622900363c14483a997490214a9d2fc41e7596c318863d55" => :mojave
    sha256 "0f9e30d5bab62d992381fd999b997c9eda1c872a586e65e2d6aec8204251b5c9" => :high_sierra
    sha256 "91461b8605fadd5d1938b4ada446a54b8206ff0a1dfc7e3f7e861be6b4c93a9b" => :sierra
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
