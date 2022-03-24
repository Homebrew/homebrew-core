class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/v0.6.5.tar.gz"
  sha256 "eb63ac5a6bafda614ec128fa7be1c81e4fa54855d69c6f8cf9c632f3e40cffa3"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6405be952566e507669a68b346eabb2cdd3b35cecea297b5c75ead573598eb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b926a4b5f0d845de160ab825901f82e4af73f50121dff4abe66393f50ebb4bfe"
    sha256 cellar: :any_skip_relocation, monterey:       "9c7bbccb97ef8640b03b896db4c5fe90194a8166b6dbe37491340442563142c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "71bb3ce39818e94fa18e4a100d3c246df4b514061ae4358d4e142f32a2fafbe5"
    sha256 cellar: :any_skip_relocation, catalina:       "0b7cfdb3eacfee7c1fe43e5234678eb267ac9282f7b425fe23a56cd771f85f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cf3f0e6d15d1f0263ecd4484bb0a799762870ccc969506e1e651676239102fa"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"provider.tf").write <<~EOS
      provider "aws" {
        version = "2.39.0"
      }
    EOS

    system bin/"tfupdate", "provider", "aws", "-v", "2.40.0", testpath/"provider.tf"
    assert_match "2.40.0", File.read(testpath/"provider.tf")

    # list the most recent 5 releases
    assert_match Formula["terraform"].version.to_s, shell_output(bin/"tfupdate release list -n 5 hashicorp/terraform")

    assert_match version.to_s, shell_output(bin/"tfupdate --version")
  end
end
