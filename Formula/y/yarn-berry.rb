class YarnBerry < Formula
  desc "Modern JavaScript package manager"
  homepage "https://yarnpkg.com/"
  url "https://github.com/yarnpkg/berry/archive/refs/tags/@yarnpkg/cli/4.17.1.tar.gz"
  sha256 "e59d7ddf41ee4066de4a8c8e79696154bb830b7e9e5ee8cc3bf52beaea2e4182"
  license "BSD-2-Clause"
  head "https://github.com/yarnpkg/berry.git", branch: "master"

  livecheck do
    url :head
    regex(%r{^@yarnpkg/cli/v?(\d+(?:\.\d+)+)$}i)
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `yarn` and `yarnpkg` binaries"
  conflicts_with "hadoop", because: "both install `yarn` binaries"
  conflicts_with "yarn", because: "both install `yarn` and `yarnpkg` binaries"

  def install
    system "node", "scripts/run-yarn.js", "build:cli"
    bin.install "packages/yarnpkg-cli/bundles/yarn.js" => "yarn"
    bin.install_symlink bin/"yarn" => "yarnpkg"
  end

  def caveats
    <<~EOS
      yarn-berry requires a Node.js installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yarn --version")

    ENV["YARN_ENABLE_TELEMETRY"] = "0"
    ENV["YARN_ENABLE_IMMUTABLE_INSTALLS"] = "false"

    (testpath/"fixture/package.json").write <<~JSON
      {
        "name": "fixture",
        "version": "1.0.0",
        "main": "index.js"
      }
    JSON
    (testpath/"fixture/index.js").write <<~JS
      module.exports = "Yarn Berry works";
    JS

    (testpath/"package.json").write <<~JSON
      {
        "name": "test",
        "private": true,
        "dependencies": {
          "fixture": "portal:./fixture"
        }
      }
    JSON
    (testpath/"test.js").write <<~JS
      console.log(require("fixture"));
    JS

    system bin/"yarn", "install"
    assert_equal "Yarn Berry works\n", shell_output("#{bin}/yarn node test.js")
  end
end
