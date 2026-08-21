class WormScraper < Formula
  desc "Scrape Worm, Ward, and Glow-worm web serials into EPUB ebooks"
  homepage "https://github.com/domenic/worm-scraper"
  url "https://registry.npmjs.org/worm-scraper/-/worm-scraper-9.2.2.tgz"
  sha256 "c8ead11dfbfeeed92c6e02fd9de88c6ef293564e017ab678d3ebf7d3f9f6c4c1"
  license "WTFPL"
  head "https://github.com/domenic/worm-scraper.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "78160f3a123f883d8c93deadc9ac45f1b7d7bec753ad0d900b0fae773912aca8"
    sha256 cellar: :any, arm64_sequoia: "78160f3a123f883d8c93deadc9ac45f1b7d7bec753ad0d900b0fae773912aca8"
    sha256 cellar: :any, arm64_sonoma:  "78160f3a123f883d8c93deadc9ac45f1b7d7bec753ad0d900b0fae773912aca8"
    sha256 cellar: :any, sonoma:        "a527ad1b5502bfb87c4af4f21b80f3d74b98bf6757067096b3501adc95df40e6"
    sha256 cellar: :any, arm64_linux:   "23f86398abad56a5233a70aaed9de6c299a083f550164873d4cd5e21e798b088"
    sha256 cellar: :any, x86_64_linux:  "277071885b9a5b54c078b1bc101a13d11a311b9e43081cd1e1b9598b86149534"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/worm-scraper/node_modules"
    node_modules.glob("{bare-fs,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    staging = testpath/"staging/worm"
    (staging/"OEBPS").mkpath
    (staging/"META-INF").mkpath
    (staging/"mimetype").write "application/epub+zip"
    (staging/"OEBPS/chapter.xhtml").write "<html><body>Homebrew</body></html>"
    (staging/"META-INF/container.xml").write "<container/>"

    epub = testpath/"test.epub"
    system bin/"worm-scraper", "zip", "--staging=#{testpath}/staging", "--out=#{epub}"
    assert_path_exists epub
    assert_equal "application/epub+zip", shell_output("unzip -p #{epub} mimetype")
  end
end
