class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  # Should only be updated if the new version is listed as a stable release on the homepage
  url "https://yarnpkg.com/downloads/1.12.3/yarn-v1.12.3.tar.gz"
  sha256 "02cd4b589ec22c4bdbd2bc5ebbfd99c5e99b07242ad68a539cb37896b93a24f2"

  bottle :unneeded

  depends_on "node" => :recommended

  conflicts_with "hadoop", :because => "both install `yarn` binaries"

  def install
    libexec.install Dir["*"]
    (bin/"yarn").write_env_script "#{libexec}/bin/yarn.js", :PREFIX => HOMEBREW_PREFIX, :NPM_CONFIG_PYTHON => "/usr/bin/python"
    (bin/"yarnpkg").write_env_script "#{libexec}/bin/yarn.js", :PREFIX => HOMEBREW_PREFIX, :NPM_CONFIG_PYTHON => "/usr/bin/python"
    inreplace "#{libexec}/package.json", '"installationMethod": "tar"', '"installationMethod": "homebrew"'
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
    system bin/"yarn", "add", "fsevents", "--build-from-source=true"
  end
end
