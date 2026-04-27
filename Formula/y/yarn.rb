class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  url "https://registry.npmjs.org/@yarnpkg/cli-dist/-/cli-dist-4.14.1.tgz"
  sha256 "050441cd452e222ec1b8409415174e81a15a1e8ca5d76236c89f1a4cc9984bcb"
  license "BSD-2-Clause"

  livecheck do
    url "https://registry.npmjs.org/@yarnpkg/cli-dist/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "edb63a1b15d560263270324b63bee4c2aa8145197636a755436cc14424fc1e12"
  end

  depends_on "node" => :test

  conflicts_with "corepack", because: "both install `yarn` and `yarnpkg` binaries"
  conflicts_with "hadoop", because: "both install `yarn` binaries"

  def install
    libexec.install buildpath/"bin"
    libexec.install buildpath/"package.json"

    (bin/"yarn").write_env_script libexec/"bin/yarn.js", PREFIX: HOMEBREW_PREFIX
    bin.install_symlink bin/"yarn" => "yarnpkg"
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
  end
end
