require "language/node"

class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  url "https://github.com/unisonweb/unison.git",
      tag:      "release/M5h",
      revision: "68d6f93d3bdd3663aee6ec7e16fee4eedc6df26b"
  version "M5h"
  license "MIT"
  head "https://github.com/unisonweb/unison.git", branch: "trunk"

  livecheck do
    url :stable
    regex(%r{^release/(M\d+[a-z]*)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ddc487c9b10c453378dcb06d07affedd8624ce5e0b26033895ffe90f7aadec7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2a9878e90be193ffb87c9a75c9bbe0fa32b64cd147afc3fc96e8ffd4482f0c9"
    sha256 cellar: :any_skip_relocation, ventura:        "effae902fd1f2fd96ae76ddcba33e17254f0b57aa0ebb18bf04074a09a61d2d5"
    sha256 cellar: :any_skip_relocation, monterey:       "7d347157b46e3cbb6fc2edcac6517b87b276fc3f3f479f77e51c790b29f03c39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39ef06872b4adfcb6d330b308beac6acac160fd1899abcb04348ea1b242986dd"
  end

  depends_on "ghc@9.2" => :build # GHC 9.4 PR: https://github.com/unisonweb/unison/pull/4009
  depends_on "haskell-stack" => :build
  depends_on "node" => :build

  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "ncurses"
  end

  on_arm do
    depends_on "elm" => :build
  end

  resource "local-ui" do
    url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/M5h.tar.gz"
    version "M5h"
    sha256 "febd72be5f546962c8bf44bde1332d88a32a3a8c457a560f885ca95a3a856f4d"
  end

  def install
    jobs = ENV.make_jobs
    ENV.deparallelize

    # Build and install the web interface
    resource("local-ui").stage do
      system "npm", "install", *Language::Node.local_npm_install_args
      if Hardware::CPU.arm?
        # Replace x86_64 elm binary to avoid dependency on Rosetta
        elm = Pathname("node_modules/elm/bin/elm")
        elm.unlink
        elm.parent.install_symlink Formula["elm"].opt_bin/"elm"
      end
      # HACK: Flaky command occasionally stalls build indefinitely so we force fail
      # if that occurs. Problem seems to happening while running `elm-json install`.
      # Issue ref: https://github.com/zwilias/elm-json/issues/50
      Timeout.timeout(300) do
        system "npm", "run", "ui-core-install"
      end
      system "npm", "run", "build"

      prefix.install "dist/unisonLocal" => "ui"
    end

    stack_args = [
      "-v",
      "--system-ghc",
      "--no-install-ghc",
      "--skip-ghc-check",
      "--copy-bins",
      "--local-bin-path=#{buildpath}",
    ]

    system "stack", "-j#{jobs}", "build", "--flag", "unison-parser-typechecker:optimized", *stack_args

    prefix.install "unison" => "ucm"
    bin.install_symlink prefix/"ucm"
  end

  test do
    # Ensure the local-ui version matches the ucm version
    assert_equal version, resource("local-ui").version

    (testpath/"hello.u").write <<~EOS
      helloTo : Text ->{IO, Exception} ()
      helloTo name =
        printLine ("Hello " ++ name)

      hello : '{IO, Exception} ()
      hello _ =
        helloTo "Homebrew"
    EOS

    (testpath/"hello.md").write <<~EOS
      ```ucm
      .> project.create test
      test/main> load hello.u
      test/main> add
      test/main> run hello
      ```
    EOS

    assert_match "Hello Homebrew", shell_output("#{bin}/ucm --codebase-create ./ transcript.fork hello.md")
  end
end
