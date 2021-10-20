class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/v0.6.1.tar.gz"
  sha256 "489ef697be6e203872518c7e711299885762595920ff3b0e7c09e800c8392de9"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "154fdca63039e5c3ed1a2700f601958732233f9db5fc74fec562023dac718b7e"
    sha256 cellar: :any_skip_relocation, big_sur:       "0c94bb7fde4b8fec7793e8812bd17875f365c527cdb5360b586ff6671123c78a"
    sha256 cellar: :any_skip_relocation, catalina:      "a3fa447c24b9a8e8cda3f952457d28a65992de3b7693a86cacd4ac681fdf9bc9"
    sha256 cellar: :any_skip_relocation, mojave:        "51ff4610d05ec391a54b55261847161902706fa5bb4d86e826d7f754e4942028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1122a930470b2e049d94ff2f43673937bdb36ae7bfa23306e4d9f600183c72c3"
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
