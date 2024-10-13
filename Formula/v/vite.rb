class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.4.8.tgz"
  sha256 "0ea4fafa19783ea955192478cd7ef2b5b305a4f08752018c38eb1bdade3af888"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ced252645cb1c94a24f4d9a182e8f52b0f1aa09542ce72ec725eec877dd7839d"
    sha256 cellar: :any,                 arm64_sonoma:  "ced252645cb1c94a24f4d9a182e8f52b0f1aa09542ce72ec725eec877dd7839d"
    sha256 cellar: :any,                 arm64_ventura: "ced252645cb1c94a24f4d9a182e8f52b0f1aa09542ce72ec725eec877dd7839d"
    sha256 cellar: :any,                 sonoma:        "9603740ed9386b4f68eba628718d740feac4a2731be70787b851264baf165f1d"
    sha256 cellar: :any,                 ventura:       "9603740ed9386b4f68eba628718d740feac4a2731be70787b851264baf165f1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc66ddadb56c8941b25c92303b5e330c5cfd59ba021c68ed59ff9d39e209e468"
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
