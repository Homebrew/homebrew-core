class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.12.8.tar.gz"
  sha256 "6a188f8f87964c99e2a4c1aa3b9292f280b9a44ba4de5250d3484e50c30baccc"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0777c47604ca906d3319844e80f8724b4e73f7a90cbb683705fbe5f803cdfa1d" => :sierra
    sha256 "c335a0310763c59c6e45dca0da085d7e9cafa65e321e0553b0057357b86a219f" => :el_capitan
    sha256 "b035e1dcf0ff18a2795b66fbad4b8def9343c1985e121608731f2e4ab365e9a3" => :yosemite
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
