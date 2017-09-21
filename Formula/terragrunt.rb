class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.3.tar.gz"
  sha256 "6e5f7c26054b91e0cce0de1deaa204d194bb78a73507d68b9a08b43dc217fe6a"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "49698ebf2cf3c2da040178f067cd54a8fafe515c17c6f313d792b8985f006227" => :high_sierra
    sha256 "d94beeeadc040eaaefefbf7d4f075dbb3776d7aa2ff69b76fa3752dc3a0cc8ab" => :sierra
    sha256 "77206ec14ada82f4c4f2c9295186f180781cb101880b02793ed709d021cf27c0" => :el_capitan
    sha256 "bdd883f575e88a8b82fb30e4135b9365f0b4c0331bf426941af103c281544cfa" => :yosemite
  end

  depends_on "glide" => :build
  depends_on "go" => :build
  depends_on "terraform"

  resource "aws-sdk-go" do
    url "https://github.com/aws/aws-sdk-go",
        :using => :git,
        :revision => "00fb2125993965df739fa3398b03bef3eb2e198f"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    mkdir_p buildpath/"src/github.com/gruntwork-io/"
    ln_s buildpath, buildpath/"src/github.com/gruntwork-io/terragrunt"
    (HOMEBREW_CACHE/"glide_home/#{name}/cache/src/https-github.com-aws-aws-sdk-go").install resource("aws-sdk-go")
    system "glide", "install"
    system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=v#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
