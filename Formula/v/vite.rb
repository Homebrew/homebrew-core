class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.1.0.tgz"
  sha256 "7bd8f72abd90c5adcadb236b26841ecdd98e947ee4c22d76099c353b38144b5c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b4cda05271d5ea5143f6a32845b5b744e8f49d0911c7d4bd2d86a637a594f45b"
    sha256 cellar: :any,                 arm64_sequoia: "6287d766fe46ef1c5f02cf0d203afed0b553a33b49f1f336b3d28ef0f0f21c8d"
    sha256 cellar: :any,                 arm64_sonoma:  "6287d766fe46ef1c5f02cf0d203afed0b553a33b49f1f336b3d28ef0f0f21c8d"
    sha256 cellar: :any,                 sonoma:        "4d5f1f36ddfe589921825d516d4f509e29e825d8d583433b5b55b3f0c2f8bf35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7df9551ceed34c7610adc2f67d40f80caaf4c30f33dc38952a468e63a7f0389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bede86f8fb56a51b9b9f6f77101bdc5ee05df85bf54b5a455dfb723ae88b983b"
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
