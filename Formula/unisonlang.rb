require "language/node"

class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  url "https://github.com/unisonweb/unison.git",
      tag:      "release/M4g",
      revision: "77e636320d9d886e561264e4df5511840af94cc0"
  version "M4g"
  license "MIT"
  head "https://github.com/unisonweb/unison.git", branch: "trunk"

  livecheck do
    url :stable
    regex(%r{^release/(M\d+[a-z]*)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e4367ca5c865358ca1131028819fb8f5227712f56e543cdc323531dead280e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d25efdc2b8df048b74a27183902f20edb5615ab119e33502b212900baa7c248"
    sha256 cellar: :any_skip_relocation, ventura:        "63d5a21d23f4bad2ef1de3992269818f24ad4c68533b90ccd75a47742ae9ac01"
    sha256 cellar: :any_skip_relocation, monterey:       "9cb24e4b01ae3ac3131dbbaf951e3e309d980b9bf6cd5d7a1ea4300da9098807"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2f9a57ba304b7b6bf22e59b22d7a8e144d0753139b2ed0656d8d8901158f5cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a11603a95392b83704faa61d3ffe904f1beba93768d39053e0737bbb38997a7"
  end

  depends_on "ghc@8.10" => :build
  depends_on "haskell-stack" => :build
  depends_on "node@18" => :build

  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build
  uses_from_macos "zlib"

  resource "local-ui" do
    url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/M4g.tar.gz"
    sha256 "b9946ef2912dcbc9fca928acf9b7af44308e668faff7c95d8396506d23897352"
    version "M4g"
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
