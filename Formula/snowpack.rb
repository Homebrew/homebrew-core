require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.5.3.tgz"
  sha256 "be2e93ac0472703402480d9d3236d1ba97bb28e4cb6f8be947eb00df34a827b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b3b9f1bf13a83884a1a39c3bb82ad4e4a270054f2062727baf3b10ff1d3c2f40"
    sha256 cellar: :any_skip_relocation, big_sur:       "88006ddf2f71d1ee159ac898819fb6e1e4cf3610aeb88c6d7cb6b8a1efb3740b"
    sha256 cellar: :any_skip_relocation, catalina:      "88006ddf2f71d1ee159ac898819fb6e1e4cf3610aeb88c6d7cb6b8a1efb3740b"
    sha256 cellar: :any_skip_relocation, mojave:        "88006ddf2f71d1ee159ac898819fb6e1e4cf3610aeb88c6d7cb6b8a1efb3740b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    mkdir "work" do
      system bin/"snowpack", "init"
      assert_predicate testpath/"work/snowpack.config.js", :exist?

      inreplace testpath/"work/snowpack.config.js",
        "  packageOptions: {\n    /* ... */\n  },",
        "  packageOptions: {\n    source: \"remote\"\n  },"
      system bin/"snowpack", "add", "react"
      deps_contents = File.read testpath/"work/snowpack.deps.json"
      assert_match(/\s*"dependencies":\s*{\s*"react": ".*"\s*}/, deps_contents)

      assert_match "Build Complete", shell_output("#{bin}/snowpack build")
    end
  end
end
