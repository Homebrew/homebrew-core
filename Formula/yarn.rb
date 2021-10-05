class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/1.22.15/yarn-v1.22.15.tar.gz"
  sha256 "0c2841b9423f0fb9657ae6b18873f39551396ec242bfb882b11bed9e4648235e"
  license "BSD-2-Clause"

  livecheck do
    skip("1.x line is frozen and features/bugfixes only happen on 2.x")
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b9a156f01c5a5691efcb5f32731b6e3b3a6950d8882fb54e75662ee6bbfead67"
  end

  depends_on "node"

  conflicts_with "hadoop", because: "both install `yarn` binaries"

  def install
    libexec.install Dir["*"]
    (bin/"yarn").write_env_script "#{libexec}/bin/yarn.js",
      PREFIX:            HOMEBREW_PREFIX,
      NPM_CONFIG_PYTHON: "/usr/bin/python"
    (bin/"yarnpkg").write_env_script "#{libexec}/bin/yarn.js",
      PREFIX:            HOMEBREW_PREFIX,
      NPM_CONFIG_PYTHON: "/usr/bin/python"
    inreplace "#{libexec}/lib/cli.js", "/usr/local", HOMEBREW_PREFIX
    inreplace "#{libexec}/package.json", '"installationMethod": "tar"', '"installationMethod": "homebrew"'
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
    on_macos do
      # macOS specific package
      system bin/"yarn", "add", "fsevents", "--build-from-source=true"
    end
  end
end
