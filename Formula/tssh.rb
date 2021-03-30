class Tssh < Formula
  desc "SSH Lightweight management tools"
  homepage "https://github.com/luanruisong/tssh"
  url "https://github.com/luanruisong/tssh/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "df8ee71630658cea3ce96cd0f5c44583c4e37a97c060fbcbe96bc7e261883852"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"tssh"
  end

  test do
    status_output = shell_output("#{bin}/tssh -e")
    assert_match "env 'TSSH_HOME' not found,please set a dir in env", status_output
  end
end
