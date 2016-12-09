class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.6.2.tar.gz"
  sha256 "17f1bc001698bf468ebbb016e2f1be29035e6e5cdca59ae05ff553dcf5945f49"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "64f45bc51e6f55dc020739a9314dc7c012eeaba17bdb58db72c0d299123f3d9e" => :sierra
    sha256 "532f534637d6f55526bc8853388300dbfe22e989e27f86b21f8a7e25e348edba" => :el_capitan
    sha256 "1c7b8a59232ef484c0766cddf9a4eb76be593a250ec4b436cc7ec63343499510" => :yosemite
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
    system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=" + version.to_s
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
