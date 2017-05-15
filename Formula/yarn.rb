class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.24.5/yarn-v0.24.5.tar.gz"
  sha256 "a7492431eedee0203faeac64e75f484e4911ab707c96c5bee4c7b97bf19c102c"
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
