class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.0.7.tgz"
  sha256 "67112269fcc78e0cae4f9531660b3037290f25f631767628ff8bec64fa51fc08"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "46f70aa8cbbebc0ebf5621a176fe930ae64f08f44cfe92d4b4f81bd7def015b3"
    sha256 cellar: :any,                 arm64_sequoia: "d59d4ea3fc64e6d2edc3819dcdbb8727ceb83de8e94d2df2beeb56439356459d"
    sha256 cellar: :any,                 arm64_sonoma:  "d59d4ea3fc64e6d2edc3819dcdbb8727ceb83de8e94d2df2beeb56439356459d"
    sha256 cellar: :any,                 sonoma:        "fb7ef67fb44945da2c0d8b9ec64866f97b5ae1a7966738ce794419140e6ae361"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c18c2bbee031bfafcd2edf105b50b7d95a3c9648c4e89f029bb149480f81b25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c29615ebe9267d89a170e919879625f4b7cd3368e6bed57f8e1ca5f38e4f3b24"
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
