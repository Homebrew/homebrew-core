class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.16.5.tar.gz"
  sha256 "6a237e5b7e51e0af328fa182875c5bd98a4e7370bfdaa6bbebde2d2bf2d92ef0"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc04b00995f625744bd24a401e48a67bbeabcc4c39c68df8baf388d665e5be05" => :high_sierra
    sha256 "0e315c950f0aebeb39ab6347119b6f9ec37d6ab65b0ab8414966f9291f3df5b9" => :sierra
    sha256 "e51297936170d710e33a0ee28beac25a163272cc61beccec2fff501e9dd734c9" => :el_capitan
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
