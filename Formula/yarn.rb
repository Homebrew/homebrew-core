class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.21.3/yarn-v0.21.3.tar.gz"
  sha256 "0946a4d1abc106c131b700cc31e5c3aa5f2205eb3bb9d17411f8115354a97d5d"
  revision 1
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
