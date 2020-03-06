class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  # Should only be updated if the new version is listed as a stable release on the homepage
  url "https://yarnpkg.com/downloads/1.22.1/yarn-v1.22.1.tar.gz"
  sha256 "3af905904932078faa8f485d97c928416b30a86dd09dcd76e746a55c7f533b72"

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
