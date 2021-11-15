class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/1.22.17/yarn-v1.22.17.tar.gz"
  sha256 "267982c61119a055ba2b23d9cf90b02d3d16c202c03cb0c3a53b9633eae37249"
  license "BSD-2-Clause"

  livecheck do
    skip("1.x line is frozen and features/bugfixes only happen on 2.x")
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2d9cb60cd75e22835f7d7b840168aa5a5d8999d82f0eea75315cb3193edc8c9e"
  end

  depends_on "node"

  conflicts_with "hadoop", because: "both install `yarn` binaries"
  conflicts_with "corepack", because: "both install `yarn` and `yarnpkg` binaries"

  def install
    libexec.install buildpath.glob("*")
    (bin/"yarn").write_env_script libexec/"bin/yarn.js",
                                  PREFIX:            HOMEBREW_PREFIX,
                                  NPM_CONFIG_PYTHON: which("python3")
    (bin/"yarnpkg").write_env_script libexec/"bin/yarn.js",
                                      PREFIX:            HOMEBREW_PREFIX,
                                      NPM_CONFIG_PYTHON: which("python3")
    inreplace libexec/"lib/cli.js", "/usr/local", HOMEBREW_PREFIX
    inreplace libexec/"package.json", '"installationMethod": "tar"',
                                      "\"installationMethod\": \"#{tap.user.downcase}\""
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
