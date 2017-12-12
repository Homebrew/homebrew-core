class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/1.3.2/yarn-v1.3.2.tar.gz"
  sha256 "6cfe82e530ef0837212f13e45c1565ba53f5199eec2527b85ecbcd88bf26821d"

  bottle :unneeded

  depends_on "node" => :recommended

  conflicts_with "hadoop", :because => "both install `yarn` binaries"

  def install
    libexec.install Dir["*"]
    (bin/"yarn").write_env_script "#{libexec}/bin/yarn.js", :PREFIX => HOMEBREW_PREFIX
    (bin/"yarnpkg").write_env_script "#{libexec}/bin/yarn.js", :PREFIX => HOMEBREW_PREFIX
    inreplace "#{libexec}/package.json", '"installationMethod": "tar"', '"installationMethod": "homebrew"'
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
  end
end
