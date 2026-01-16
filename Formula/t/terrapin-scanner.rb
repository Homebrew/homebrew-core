class TerrapinScanner < Formula
  desc "Vulnerability scanner for the Terrapin attack"
  homepage "https://terrapin-attack.com/"
  url "https://github.com/RUB-NDS/Terrapin-Scanner/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "3dde1f19e9228a2a284d73c63b193fdf775cb993945fb328cd01e3a6cc834bf1"
  license "Apache-2.0"
  head "https://github.com/RUB-NDS/Terrapin-Scanner.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "741220ba0403c3fef850bee62a4e95bc709a6c09b8c8fd649dedcbec624a7c71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3d313ceecb351ed4b58d37e59fefe4092122577466cf8df2eb21fac0aca78514"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7f6c8f5b37b3e428566572156b3b2aafd3cbae6b682bb816e2a7383d12b3e87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "debf3a1d1766ae89e3602df352d89cc6ae5e0d39c8f464c602a8f7bfb6bec82b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d10e5ad979f31d9b56e74f743ea6df1db26ee31e15e9bce07d55ae11355fc5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "938c69dc59167cc7623e247801c78718b50153c920d8ccab9eb8ed605afcd542"
    sha256 cellar: :any_skip_relocation, ventura:        "71fa69fc56d13745e3ec2b4d69cb428da7d648fa0fc04ae3e57631943021992b"
    sha256 cellar: :any_skip_relocation, monterey:       "dde6c16e39d7fc0bd16b4657b516dfc18d671b5aa86af5b7181e675428c24ae0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "97b45e2b36eb504254135533af46052f9962759842d570fda198783847bd0884"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d30e5880884a5379fd5a39238feac53605a78ef62c41a4c4cc591c338968a0db"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"Terrapin-Scanner")
  end

  test do
    output = shell_output("#{bin}/Terrapin-Scanner --connect localhost:2222 2>&1", 2)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/Terrapin-Scanner --version")
  end
end
