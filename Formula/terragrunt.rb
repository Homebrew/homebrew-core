class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.23.tar.gz"
  sha256 "84289ae6b93281cb9f6bfddba4ec305384eeaf63596445375ed25dd024398e7e"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5644d7c8613bba418ea66df3d556e4000c8b4cd579b678528a3bd3ec739be9ac" => :high_sierra
    sha256 "59223dd56ce4f930294cc3a4831e3d9e72037b939fa5ab7731dce3d1e8fecf9d" => :sierra
    sha256 "90c933dc42a86e9362b02d4c4e2afbbec1afcd7b2ad3dbe1ed1bdd98234e48df" => :el_capitan
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
