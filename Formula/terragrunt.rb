class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.12.20.tar.gz"
  sha256 "c2bac23a4788748f28dbf198339e637fd2dead9d8cabe0f4e384f8287b769b95"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "07f2f3151869ae450552fa8177ae4af2058629a299c255c09c7e5a1600cf8d18" => :sierra
    sha256 "da989a4d796536a6ca6e3520dd9ae23f7c78d0de5254f31a298867143ef4a5c2" => :el_capitan
    sha256 "7fec88b97f14148c92e2277c2edfabd2f2dc5371d200042685eff3969e76d641" => :yosemite
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
