require "language/node"

class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  url "https://github.com/unisonweb/unison.git",
      tag:      "release/M5c",
      revision: "5e428a7701005710ac05e9bf30d1547edd8f25e9"
  version "M5c"
  license "MIT"
  head "https://github.com/unisonweb/unison.git", branch: "trunk"

  livecheck do
    url :stable
    regex(%r{^release/(M\d+[a-z]*)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b9fb7bcd2579fa83e38e192bca8458f9d64a69e340872070b958b3c8ba2ccff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51ef67afce4c2f5c19129fdd06101f142db9feb3c2be56388bb96cd8502b1bba"
    sha256 cellar: :any_skip_relocation, ventura:        "2f85c99bf33b350380933fa67a222827ef2eaba16a5fcb6b206dee303c875fd7"
    sha256 cellar: :any_skip_relocation, monterey:       "e60accc2a84b3d8fa001fb7da9132b9d82fd6d2607e8d3ded872d1d4eeef7114"
    sha256 cellar: :any_skip_relocation, big_sur:        "166c193bb3c83c683b6df7f8c4a48d3d46c960103b403107590154d3cd615ddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae23dafd3afa7e35fe6c3c98d1db200fd0b1a8ff4a23e0dd40263e20397558be"
  end

  depends_on "ghc@8.10" => :build # GHC 9.2 open PR: https://github.com/unisonweb/unison/pull/3642
  depends_on "haskell-stack" => :build
  depends_on "node@18" => :build

  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build
  uses_from_macos "zlib"

  resource "local-ui" do
    url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/M4h.tar.gz"
    version "M5c"
    sha256 "cac7ddd1cbac628e54dbf56d879cb0a22f2b70ef3e711cf51b9e05cd5e409e44"
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
