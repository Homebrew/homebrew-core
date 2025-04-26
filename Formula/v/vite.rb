class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.3.3.tgz"
  sha256 "43d6e8e4aae98a4898699e06a904dadd5b24f736a9aef5bb3d2a108e8580caef"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1ab91f5a4ea16223039a5f4ecd220e59fb4eec3e9538509eff64cd794f62e981"
    sha256 cellar: :any,                 arm64_sonoma:  "1ab91f5a4ea16223039a5f4ecd220e59fb4eec3e9538509eff64cd794f62e981"
    sha256 cellar: :any,                 arm64_ventura: "1ab91f5a4ea16223039a5f4ecd220e59fb4eec3e9538509eff64cd794f62e981"
    sha256 cellar: :any,                 sonoma:        "3f5007a5939ad2b34e4063c373cbaa248620e7e3241966c670b71b836dcdb2dd"
    sha256 cellar: :any,                 ventura:       "3f5007a5939ad2b34e4063c373cbaa248620e7e3241966c670b71b836dcdb2dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8451500640157c033b452b81a6767e5032c060b37d92c0a7bc7e0254fa447003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9918ee43552bca83920133e030a3dc9ac22fd4f840f2aae76407b21585535ba"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
