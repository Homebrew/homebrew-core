require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-21.2.2.tgz"
  sha256 "6b51ebd87b6f8da801a19620e058a303b7a9078d868f7b87e6067d14f111aba3"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "79fce2ada65bda3b75f5df6a8787be3b8b942d0e2d5c58a9d0373b2c7ce7a075" => :big_sur
    sha256 "b6676fc47590426b78833c10b0cc04aebe80ed9e55b8a939060d943ca0173ab9" => :arm64_big_sur
    sha256 "d016df1cff85ff21a026696d7f934eb51bfa2b449ef283d0ce8848d01a1a9e96" => :catalina
    sha256 "ba17b5562f6b291a71d3c57c16dc7678fa31f303c93846e6ae466d8c20d9abb7" => :mojave
  end

  depends_on "node"

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "exports.default = getUpdateCommand",
                               "exports.default = async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
