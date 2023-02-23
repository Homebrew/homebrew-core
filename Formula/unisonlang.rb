require "language/node"

class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  url "https://github.com/unisonweb/unison.git",
      tag:      "release/M4h",
      revision: "b5fca58162798dc8635bedd200eb735a707a7fe8"
  version "M4h"
  license "MIT"
  head "https://github.com/unisonweb/unison.git", branch: "trunk"

  livecheck do
    url :stable
    regex(%r{^release/(M\d+[a-z]*)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c541dcfcddb9b8dd70b2f20112b8e625ef7cf49586346c296a27a0d467ed46a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07621b9a346b7f8c376cf1dea0340a151d9f21d7a8aebf0337115b8b5786cb94"
    sha256 cellar: :any_skip_relocation, ventura:        "b6011f1707202fa795807b1d7580f42844164ab6f85355552eff4d129593a6a7"
    sha256 cellar: :any_skip_relocation, monterey:       "4b657b216297eb54b15a102727457e2909303b6f3b5a4759e2919e780d3130c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe296b92d1f0a9968cc25eb12f1fb5b836e1aa270a17bde5544eca857ee29cc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c3c01e379808478c8f1473d97d89aa7c4cefd451ce71f00aeecaa5f32baf813"
  end

  depends_on "ghc@8.10" => :build # GHC 9.2 open PR: https://github.com/unisonweb/unison/pull/3642
  depends_on "haskell-stack" => :build
  depends_on "node@18" => :build

  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build
  uses_from_macos "zlib"

  resource "local-ui" do
    url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/M4g.tar.gz"
    sha256 "b9946ef2912dcbc9fca928acf9b7af44308e668faff7c95d8396506d23897352"
    version "M4h"
  end

  def install
    jobs = ENV.make_jobs
    ENV.deparallelize

    # Build and install the web interface
    resource("local-ui").stage do
      system "npm", "install", *Language::Node.local_npm_install_args
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

    # Initialize a codebase by starting the server/repl, but then run the "exit" command
    # once everything is set up.
    pipe_output("#{bin}/ucm -C ./", "exit")

    (testpath/"hello.u").write <<~EOS
      helloTo : Text ->{IO, Exception} ()
      helloTo name =
        printLine ("Hello " ++ name)

      hello : '{IO, Exception} ()
      hello _ =
        helloTo "Homebrew"
    EOS

    assert_match "Hello Homebrew", shell_output("#{bin}/ucm -C ./ run.file ./hello.u hello")
  end
end
