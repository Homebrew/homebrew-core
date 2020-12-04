class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.36.9.tar.gz"
  sha256 "d7ab52319fd254a6b8e15d3d07b6d25727cfe5ef3dae76926ea592c9700a6a3d"
  license "MIT"

  livecheck do
    url "https://github.com/tfsec/tfsec/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "37a0cad2592c0d4f98259c958a81b380f6e11124ca099a83790c87d2691d074e" => :big_sur
    sha256 "7decf46fc99a8cfe763f7d279fa0c10b5310a5cffd81c57d6e0b67892a24b37d" => :catalina
    sha256 "dcc29967887ef80d45c643f062fc7881c15d691718ac14ce7f9bd47322e1b78f" => :mojave
  end

  depends_on "go" => :build

  resource "testfile" do
    url "https://raw.githubusercontent.com/tfsec/tfsec/2d9b76a/example/brew-validate.tf"
    sha256 "3ef5c46e81e9f0b42578fd8ddce959145cd043f87fd621a12140e99681f1128a"
  end

  def install
    system "scripts/install.sh", "v#{version}"
    bin.install "tfsec"
  end

  test do
    resource("testfile").stage do
      assert_match "No problems detected!", shell_output("#{bin}/tfsec .")
    end
  end
end
