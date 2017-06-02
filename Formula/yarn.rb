class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.24.6/yarn-v0.24.6.tar.gz"
  sha256 "c375ab86d4ca0b46addc5b462280bd42ddefb114ee0025d38044bb4610cd625d"
  head "https://github.com/yarnpkg/yarn.git"

  bottle :unneeded

  depends_on "node"

  def install
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/yarn.js" => "yarn"
    bin.install_symlink "#{libexec}/bin/yarn.js" => "yarnpkg"
    inreplace "#{libexec}/package.json", '"installationMethod": "tar"', '"installationMethod": "homebrew"'
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
  end
end
