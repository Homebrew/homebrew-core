require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.2.1.tgz"
  sha256 "43621f65b21a9cd8aa1802a129836c99a65dfa2c37200eaaa1c0c3a3df5c7c40"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "53c53a1ee34d193aa58a352985f531b67ad33b259b4c3600dc009c45c790abdf"
    sha256 cellar: :any,                 arm64_ventura:  "53c53a1ee34d193aa58a352985f531b67ad33b259b4c3600dc009c45c790abdf"
    sha256 cellar: :any,                 arm64_monterey: "53c53a1ee34d193aa58a352985f531b67ad33b259b4c3600dc009c45c790abdf"
    sha256 cellar: :any,                 sonoma:         "84daab9c55cec755d7f26bfaa7e996d9691202b244ad7070aeb15fd6a2372d6c"
    sha256 cellar: :any,                 ventura:        "84daab9c55cec755d7f26bfaa7e996d9691202b244ad7070aeb15fd6a2372d6c"
    sha256 cellar: :any,                 monterey:       "84daab9c55cec755d7f26bfaa7e996d9691202b244ad7070aeb15fd6a2372d6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68f38b461264fc1efa82ba1c623b513f1028d9881a0996b06efbdd40ce11a138"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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
