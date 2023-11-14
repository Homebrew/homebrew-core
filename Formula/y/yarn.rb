class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/1.22.20/yarn-v1.22.20.tar.gz"
  sha256 "b0c3b56a1f6f35ab5045336f357c03969a60b0e6bedfc06dd61eb4d9ca141a94"
  license "BSD-2-Clause"

  livecheck do
    skip("1.x line is frozen and features/bugfixes only happen on 2.x")
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "79b90324a5365189a144b786e9bdb3bf32be3823e9041d5f3250ea7b804dcd0b"
  end

  depends_on "node" => :test

  conflicts_with "hadoop", because: "both install `yarn` binaries"
  conflicts_with "corepack", because: "both install `yarn` and `yarnpkg` binaries"

  def install
    libexec.install buildpath.glob("*")
    (bin/"yarn").write_env_script libexec/"bin/yarn.js", PREFIX: HOMEBREW_PREFIX
    (bin/"yarnpkg").write_env_script libexec/"bin/yarn.js", PREFIX: HOMEBREW_PREFIX
    inreplace libexec/"lib/cli.js", "/usr/local", HOMEBREW_PREFIX
    inreplace libexec/"package.json", '"installationMethod": "tar"',
                                      "\"installationMethod\": \"#{tap.user.downcase}\""
  end

  def caveats
    <<~EOS
      yarn requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
    # macOS specific package
    system bin/"yarn", "add", "fsevents", "--build-from-source=true" if OS.mac?
  end
end
