require "language/node"

class Unravel < Formula
  desc "Command-line client for Clojure REPLs"
  homepage "https://github.com/pesterhazy/unravel"
  url "https://github.com/pesterhazy/unravel/archive/0.2.2.tar.gz"
  sha256 "144b2a96dc5900dada9e668f765ac63d55b97770525f1c994b8b41084048a9cc"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc60902e32d40beca8a58844d98e27d9fe45cb735154dd88d492ba243a9753da" => :mojave
    sha256 "ea6f701ccd6c808661420c77e5c2b2b73b3b3a3a646f18e91e235c3c3843a560" => :high_sierra
    sha256 "9110d228db2cf18125861f289705c135fc7c5ac9b3ebdd01aa69726d7b758ed3" => :sierra
    sha256 "34d1aca980ed2894b743656b271aa42a36b69a4828763c1c1c5ded1638110570" => :el_capitan
  end

  depends_on "lumo"
  depends_on "node"

  def install
    # This is installed by Homebrew
    inreplace "package.json", /"lumo-cljs": ".+?",/, ""
    inreplace "bin/unravel",
      '"${UNRAVEL_HOME}/node_modules/lumo-cljs/bin/lumo"', "lumo"

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    (bin/"unravel").write_env_script libexec/"bin/unravel",
      :UNRAVEL_HOME => libexec/"lib/node_modules/unravel-repl"
  end

  test do
    # We'd need a REPL to connect to in order to have a proper test
    assert_match "Socket error", shell_output("#{bin}/unravel localhost 1", 1)
  end
end
