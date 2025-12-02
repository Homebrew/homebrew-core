class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.2.6.tgz"
  sha256 "a46f01eb42f7f444b447d1e78eb773e29d133870d12e9e6de613f46acad34bcd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "286c28f218a97fa25484da0ebe8afbe3a43c3d4c27aa21cf2f69ce07776772c8"
    sha256 cellar: :any,                 arm64_sequoia: "013d30c42c37abb50be0bc9fb5f235f81aff1d3d411fbdfd30f992573c5d08a4"
    sha256 cellar: :any,                 arm64_sonoma:  "013d30c42c37abb50be0bc9fb5f235f81aff1d3d411fbdfd30f992573c5d08a4"
    sha256 cellar: :any,                 sonoma:        "12780264e56884b137d00ec3d915b0cb4bda9dfbfad0927c3f33a4b25c2a00b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08cdceaeda0f06cdf41be64d640c1956c9ac9b243137605f8368e251658d8b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd9654a532895dc83e8a8466af9192062ad31f245904d62f5306a43a27188ca7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

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
