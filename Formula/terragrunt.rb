class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.10.1.tar.gz"
  sha256 "1c06888ede598e6d719c84ba16508720f6dc236fa42bab721c1fdf0a80703fb4"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9f24e9e78cc5a1daa21170d4c757d21a19e4553eaec95d93263ac8a46a186b8" => :sierra
    sha256 "e8a3c580100790b70e246c82e145381b96b3686554305e92a6c2ce97e0f9afb3" => :el_capitan
    sha256 "4f4bfca7a7739ca142b6f5cd0004cf785414ed76f9637511c3f87212ffec18ef" => :yosemite
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
