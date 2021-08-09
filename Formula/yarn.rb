class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/1.22.11/yarn-v1.22.11.tar.gz"
  sha256 "2c320de14a6014f62d29c34fec78fdbb0bc71c9ccba48ed0668de452c1f5fe6c"
  license "BSD-2-Clause"

  livecheck do
    skip("1.x line is frozen and features/bugfixes only happen on 2.x")
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2b7e2e40cf6448ba992f94c532a20ef2ec079004293e783290dfbd6243057f24"
    sha256 cellar: :any_skip_relocation, all:          "5c8f50922a573a4fc2f15b2b5b0fb457d93312474f85b1a23dd3af7d3e072650"
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
