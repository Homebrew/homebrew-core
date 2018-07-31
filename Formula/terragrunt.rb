class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.16.4.tar.gz"
  sha256 "7b05c4f6f4e94cd695124e0cb22fc6ddf176c65208033a6e72cd8b209152e03b"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e0b105ead52ee670742d121872844bd55bf8389cfd2a1971f704b54b4ffa132" => :high_sierra
    sha256 "785f68cac14a743e8c2d8e5490c332fa8c2f231093c2076c15a90a93bbfd2eeb" => :sierra
    sha256 "036b06857499db8780ffd49301086bb81265c085c082b40ef7404fe699671ef6" => :el_capitan
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
