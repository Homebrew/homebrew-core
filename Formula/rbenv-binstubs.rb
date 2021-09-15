class RbenvBinstubs < Formula
  desc "Make rbenv aware of bundler binstubs"
  homepage "https://github.com/ianheggie/rbenv-binstubs"
  url "https://github.com/ianheggie/rbenv-binstubs/archive/v1.5.tar.gz"
  sha256 "305000b8ba5b829df1a98fc834b7868b9e817815c661f429b0e28c1f613f4d0c"
  license "MIT"
  revision 1
  head "https://github.com/ianheggie/rbenv-binstubs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6c6c87e94079363fe4305e4798c2e26af71c71662ec3cdc9cc62cf55a6fb41f5"
  end

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "rbenv-binstubs.bash", shell_output("rbenv hooks exec")
  end
end
