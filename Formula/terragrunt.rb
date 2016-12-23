class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.7.1.tar.gz"
  sha256 "294385956ae26f9ce08f4293ad6d15b0e4664cd71bb41550e94962b1e053a3a1"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    sha256 "a891e1913460e41d3140b59fb721cb10ddaf01c4ef7c26773a9a6cc4cb2072db" => :sierra
    sha256 "fc743ab58bdd77dff6e37d8ce820046ff57406c258e2cb781590ea4076f86b6a" => :el_capitan
    sha256 "67e655d46ed326236b816bccb8d5f105600b8fc92efb4c3e08677dc2525e2b1a" => :yosemite
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
