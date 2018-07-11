class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.16.2.tar.gz"
  sha256 "2507fba27dcb5bec9e342cfc951e3696fd1f84a0cff0b98f3745f33157f03bbd"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8a53b0673075443f2fa81325b4bac22f7ae414bff8d7c8beacb5027095f7ef4" => :high_sierra
    sha256 "15eb7aa2d918fdb71c714431e316a0d6a8a5c6714e83d51be043e22845b76568" => :sierra
    sha256 "bc6735a8703facd7b0ad432884ee6141bce4bd34e14066de42aa895a0dbb017b" => :el_capitan
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
