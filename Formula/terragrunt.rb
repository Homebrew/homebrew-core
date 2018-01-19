class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.25.tar.gz"
  sha256 "de7f0288e14c9de0ba66c92379ee37315a521642556bf0feaef91972663fb230"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "04eaac6f15e7d4747d061dd893f2ee1ea13f6ad3f612853f05e1a42ed5e6661e" => :high_sierra
    sha256 "e9014f17e210fdd73bb15ef2e524c97cd839cb2d322a779ffbadee5311637227" => :sierra
    sha256 "a034bf8fe18f4dca0bbb13eb3dd4e5df826e44ffc9146718debeeb175d4f5434" => :el_capitan
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
