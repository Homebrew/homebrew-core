class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.15.1.tar.gz"
  sha256 "8d44b1f468fcec119a8f6d308a6d5be2eab9878ef7de523176b49fec6b4b8f40"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a3e34a18184a9ba6e28852128dbe2930487ba01d4ac6d0520a2e76b5319d0b9" => :high_sierra
    sha256 "049a40a748ae198073b553c18c14cad3308de1f3461169068888f5c3dd8c7219" => :sierra
    sha256 "2f6c69ec802a94add41924fe7b42e40bc8c08a1493fc4b3bf5678630b4a86efc" => :el_capitan
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
