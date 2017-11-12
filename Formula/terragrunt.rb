class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.19.tar.gz"
  sha256 "59e5834c436b5b69f21523f43156790311b1fe1cf810ef0b0d422079249104f3"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ef1c6368eb34bc44f1498c2434ffd67f67d75a86a02e9a3915bcf65743770af" => :high_sierra
    sha256 "6570fa3a9885b05c14a24579f3903f74b36c8bfd82aa4567b27ead22cea3718b" => :sierra
    sha256 "3159e7b2a4af5c4082035954ed85f2b4ffa29a9f5fa4a27b2b632ad3ceb2f395" => :el_capitan
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
