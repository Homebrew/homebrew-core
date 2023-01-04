require "language/node"

class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  url "https://github.com/unisonweb/unison.git",
      tag:      "release/M4f",
      revision: "e5d9662c6c8802eecc63da2d6348e899d0d3ba8c"
  version "M4f"
  license "MIT"
  head "https://github.com/unisonweb/unison.git", branch: "trunk"

  livecheck do
    url :stable
    regex(%r{^release/(M\d+[a-z]*)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3383767c375c4ed4cd435ada8ad1a41c3a37caa0b5862ba0e87146bc17469e16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a038983ab8e47486759ab05c768457e7c70938db34d65e20d03070e39e2f7b62"
    sha256 cellar: :any_skip_relocation, ventura:        "5ddfbca2b562432ef38cb34b0d06862ec9d1add35dde8445114bff0b735322c8"
    sha256 cellar: :any_skip_relocation, monterey:       "38e235af4c9ec469bdc8b3030ae61ef490d84a0133a3f0827606ebb2d4dc9944"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ffaf5bba561b915bcf2cddb4e151f5b3d3ee99ff6a01df494a099797e96e34d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e769988727a8c2b57802d92eedf7126acad0e085972e8b60a05860cd6dba2270"
  end

  depends_on "ghc@8.10" => :build
  depends_on "haskell-stack" => :build
  depends_on "node@18" => :build

  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build
  uses_from_macos "zlib"

  resource "local-ui" do
    url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/M4f.tar.gz"
    sha256 "868cc77c936b15ba67818295913fc4e9da44077f780a30bfe7bee307802e3b18"
    version "M4f"
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
