require "language/node"

class Yakyak < Formula
  desc "Desktop chat client for Google Hangouts"
  homepage "https://github.com/yakyak/yakyak"
  url "https://github.com/yakyak/yakyak/archive/v1.4.0.tar.gz"
  sha256 "2e7c71ce4d6c1abf78e81f3d0e9470ede17d187bdd2fcf51a2b30c6e757a390e"
  head "https://github.com/yakyak/yakyak.git"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "deploy:darwin-x64"
    prefix.install "dist/darwin-x64/YakYak.app"
    bin.install_symlink prefix/"Yakyak.app/Contents/MacOS/YakYak"
  end

  test do
    `#{bin}/yakyak -h`
    assert_equal(0, $?.exitstatus, "yakyak -h exited with unexpected status code")
  end
end
