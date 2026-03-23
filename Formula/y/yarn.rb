class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/1.22.22/yarn-v1.22.22.tar.gz"
  sha256 "88268464199d1611fcf73ce9c0a6c4d44c7d5363682720d8506f6508addf36a0"
  license "BSD-2-Clause"

  livecheck do
    skip("1.x line is frozen and features/bugfixes only happen on 2+")
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "edb63a1b15d560263270324b63bee4c2aa8145197636a755436cc14424fc1e12"
  end

  depends_on "node" => :test

  conflicts_with "corepack", because: "both install `yarn` and `yarnpkg` binaries"
  conflicts_with "hadoop", because: "both install `yarn` binaries"

  def install
    libexec.install buildpath.glob("*")
    (bin/"yarn").write_env_script libexec/"bin/yarn.js", PREFIX: HOMEBREW_PREFIX
    bin.install_symlink bin/"yarn" => "yarnpkg"
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
