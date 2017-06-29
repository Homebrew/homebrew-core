class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.27.3/yarn-v0.27.3.tar.gz"
  sha256 "0685bad9e0857eddb401f5c18d38a01e0337e06508bda245ee803d915a932639"
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
