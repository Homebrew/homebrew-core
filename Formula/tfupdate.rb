class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/v0.6.5.tar.gz"
  sha256 "eb63ac5a6bafda614ec128fa7be1c81e4fa54855d69c6f8cf9c632f3e40cffa3"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3940408c49a6cb6ba93254ce681595ad3f87b1c729b2b2cdffa524f7c57e4867"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9a234069868f6957dd9e04553c984d15634455bc441aeb5e4b05f9de8d7f647"
    sha256 cellar: :any_skip_relocation, monterey:       "987bcfc87d642b0329d0970f419453d169241d671b28d4fcafdf6bf9b662b69c"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc6f30520257e7f9e0ec2a9bcefc1ba6cf53d0d275d400e7bb930497199f8989"
    sha256 cellar: :any_skip_relocation, catalina:       "d1038eda2c1c4e0a00a49db12991ed37f3c7e392e9ba9a433fab9f05e37ffd1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5806c388f61682b2b3167efb79acbfd4799cf83a2205a8c698c79377ddbc3961"
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
