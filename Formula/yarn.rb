class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.27.5/yarn-v0.27.5.tar.gz"
  sha256 "f0f3510246ee74eb660ea06930dcded7b684eac2593aa979a7add84b72517968"
  revision 1

  devel do
    url "https://yarnpkg.com/downloads/1.0.0/yarn-v1.0.0.tar.gz"
    sha256 "0f3d47e35f391507edda1c87a3014b86c2eb32aaec00d0a4b1e7413bec63787d"
  end

  bottle :unneeded

  depends_on "node" => :recommended

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
