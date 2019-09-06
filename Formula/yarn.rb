class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  # Should only be updated if the new version is listed as a stable release on the homepage
  url "https://yarnpkg.com/downloads/1.17.3/yarn-v1.17.3.tar.gz"
  sha256 "e3835194409f1b3afa1c62ca82f561f1c29d26580c9e220c36866317e043c6f3"

  bottle :unneeded

  depends_on "node"

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
