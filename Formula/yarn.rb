class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.23.2/yarn-v0.23.2.tar.gz"
  sha256 "2e4f3c5eb0bddad10fdc08a300ab43fe0f626544893deb9e07a4497e998cb82f"
  head "https://github.com/yarnpkg/yarn.git"

  bottle :unneeded

  depends_on "node"

  def install
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/yarn.js" => "yarn"
    bin.install_symlink "#{libexec}/bin/yarn.js" => "yarnpkg"
    inreplace "#{libexec}/package.json", '"installationMethod": "tar"', '"installationMethod": "homebrew"'
  end

  def caveats; <<-EOS.undent
    You will need to set up the PATH environment variable in your
    terminal to have access to Yarn’s binaries globally. Add

      export PATH="$PATH:`yarn global bin`"

    to your profile (this may be in your .profile, .bashrc, .zshrc, etc.)
    EOS
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
  end
end
