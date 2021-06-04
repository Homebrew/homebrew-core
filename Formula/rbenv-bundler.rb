class RbenvBundler < Formula
  desc "Makes shims aware of bundle install paths"
  homepage "https://github.com/carsomyr/rbenv-bundler"
  url "https://github.com/carsomyr/rbenv-bundler/archive/1.00.tar.gz"
  sha256 "84f5456b1ac8ea4554db8fa17c99b5f5d2eafcd647f85088a5d36e805c092ba7"
  license "Apache-2.0"
  revision 1
  head "https://github.com/carsomyr/rbenv-bundler.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d99c88c9492de9f01e61f3ba4d8930dbf1b607ac50c60d23c1e2e8963bd43419"
  end

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "bundler.bash", shell_output("rbenv hooks exec")
  end
end
