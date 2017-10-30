class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.15.tar.gz"
  sha256 "c7edad7af3ce081dba868b6bd0c41b5401c86b803e7235b5c4f0df6a67413f37"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8329493ddc7f57bf3f102591dc5b15fac4dfcfa1fb46606b8bb2c06771c2935" => :high_sierra
    sha256 "3a560b273e97bce705bf6ef51492bf91063019265f4daff987ab3fb77485fc99" => :sierra
    sha256 "e0499479590bd6af14dbf56c9b8e7a7eac2d7e34adba6d55118950e83b2044e4" => :el_capitan
  end

  depends_on "glide" => :build
  depends_on "go" => :build
  depends_on "terraform"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    mkdir_p buildpath/"src/github.com/gruntwork-io/"
    ln_s buildpath, buildpath/"src/github.com/gruntwork-io/terragrunt"
    system "glide", "install"
    system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=v#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
