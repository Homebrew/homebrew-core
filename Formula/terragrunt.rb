class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.16.8.tar.gz"
  sha256 "0ba536f10f0a2901334f0ead419e454fb872a3fa777b0cede92069ebb94916ca"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9506f66085da0d81e3acac36da1263710e5c53a0acb5f908b40078a68f5955ae" => :mojave
    sha256 "86067cd14cb33e817302d499deff195576c8028fc6274c613ec66f4b183b22bf" => :high_sierra
    sha256 "a60626811c5e281e47365034268889badbb1a3d2b7065eaad8a9196d27c026fe" => :sierra
    sha256 "c238bbc939c8ce9ddc3e9512051e5e06f12cb7dd81d09f6f2461fefc74e44c3d" => :el_capitan
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
