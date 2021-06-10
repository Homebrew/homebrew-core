require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.5.7.tgz"
  sha256 "e936d1042920bd894bda9077e1d6f9c6e82d853919abbb9bb6064ba036a3ca3c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1039fdc1e36b4f4a046a2cfcfcebc08f6e9258b0f771255bd864fbf76f459a03"
    sha256 cellar: :any_skip_relocation, big_sur:       "b251c9266347b4653709305f1005036df70ec6170b7023fec7bf0aea3b38ed85"
    sha256 cellar: :any_skip_relocation, catalina:      "b251c9266347b4653709305f1005036df70ec6170b7023fec7bf0aea3b38ed85"
    sha256 cellar: :any_skip_relocation, mojave:        "b251c9266347b4653709305f1005036df70ec6170b7023fec7bf0aea3b38ed85"
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
