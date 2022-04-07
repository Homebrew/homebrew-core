require "language/node"

class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  url "https://github.com/unisonweb/unison.git",
      tag:      "release/M2l",
      revision: "97cce8d23147df30b0f80ae745968db09f4e1a44"
  version "1.0.0-M2l"
  license "MIT"
  head "https://github.com/unisonweb/unison.git", branch: "trunk"

  depends_on "haskell-stack" => :build
  depends_on "node" => :build

  resource "unison-ui" do
    url "https://github.com/unisonweb/codebase-ui.git",
        tag:      "release/M2l",
        revision: "ad64aef1db2746a8fa8bcbeb8651c462509dfb08"
  end

  def install
    # Build the ucm binary
    system "stack", "build", "--flag", "unison-parser-typechecker:optimized"

    # Install the ucm binary
    local_install_root = Pathname.new `stack path | awk '/local-install-root/{print $2}'`.to_s.strip
    cp local_install_root/"bin/unison", prefix/"ucm"
    bin.install_symlink prefix/"ucm"

    # Build the web interface
    resource("unison-ui").stage buildpath/"build-ui"
    cd "build-ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end

    # Install the web interface
    prefix.install "build-ui/dist/unisonLocal" => "ui"
  end

  test do
    (testpath/"getbase.md").write <<~EOS
      ```ucm
      .> pull https://github.com/unisonweb/base:.releases._latest .base
      ```
    EOS
    system "ucm", "transcript", testpath/"getbase.md"
  end
end
