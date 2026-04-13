class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.0.8.tgz"
  sha256 "94a7ceeee92b7f61e660f4b233d1f7e3f2d9f581816ac2de791ddea99587116a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "93f97fe67111b0a8b7ed8334f8e07dfbb70b379f7d13623ade837edc5b69f031"
    sha256 cellar: :any,                 arm64_sequoia: "404ff8d9bc099f2ba6cfb9bf7b2923edfa74333c11abbb553ccb0ec24405a71a"
    sha256 cellar: :any,                 arm64_sonoma:  "404ff8d9bc099f2ba6cfb9bf7b2923edfa74333c11abbb553ccb0ec24405a71a"
    sha256 cellar: :any,                 sonoma:        "e8a4703bf753279930bd65b58cfdff8d0cf473b8dff47cc50c3b1b0185aea76c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfc234887f1fe8cc7ccbf90e1d7dfd542f2896f93a3e3326a34176a65c1b3ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "545c0588a4726879131198bd111ac0c88d3e5f5cb35aad8ce30aa2498f44eaa7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/vite/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
