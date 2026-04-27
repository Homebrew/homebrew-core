class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.0.10.tgz"
  sha256 "05354bd16ba91b67740fe493d75cf0713653f9f6e6b36417b9bdb580c4b31b56"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "560424afd2da6d4d995c973d5755d383a1d332b627d4fc146a221a981ae2c9d3"
    sha256 cellar: :any,                 arm64_sequoia: "5f52dce46c475317f2e5cfe7864fcb69812034b755b9314f0b52e16dbb59aabc"
    sha256 cellar: :any,                 arm64_sonoma:  "5f52dce46c475317f2e5cfe7864fcb69812034b755b9314f0b52e16dbb59aabc"
    sha256 cellar: :any,                 sonoma:        "4252b9416f0fdea554ca641b42b3eaac309c610bc867e3620d2df371400f8115"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d2bc1e90bcf3e37e7060d9e20d3a336d7cbd058c6ae69d33105cffb1becf915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a5493ee30d894c4b6ccfabd6d97672974bd20debf53a2b8497b31849808d832"
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
