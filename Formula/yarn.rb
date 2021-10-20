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
    sha256 cellar: :any_skip_relocation, all: "262cccd6de591bf5d4e382cb6b86cb8290d6ceb86e0d1c7b0444d11d3e9888cf"
  end

  depends_on "node"

  conflicts_with "hadoop", because: "both install `yarn` binaries"

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
