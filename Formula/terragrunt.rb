class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.16.4.tar.gz"
  sha256 "7b05c4f6f4e94cd695124e0cb22fc6ddf176c65208033a6e72cd8b209152e03b"
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
