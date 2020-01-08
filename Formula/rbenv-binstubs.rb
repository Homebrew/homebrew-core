class RbenvBinstubs < Formula
  desc "Make rbenv aware of bundler binstubs"
  homepage "https://github.com/ianheggie/rbenv-binstubs"
  url "https://github.com/ianheggie/rbenv-binstubs/archive/v1.5.tar.gz"
  sha256 "305000b8ba5b829df1a98fc834b7868b9e817815c661f429b0e28c1f613f4d0c"
  revision 1
  head "https://github.com/ianheggie/rbenv-binstubs.git"

  bottle :unneeded

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "rbenv-binstubs.bash", shell_output("rbenv hooks exec")
  end
end
