require "language/node"

class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  url "https://github.com/unisonweb/unison.git",
      tag:      "release/M3",
      revision: "97cce8d23147df30b0f80ae745968db09f4e1a44"
  version "M3"
  license "MIT"
  head "https://github.com/unisonweb/unison.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "e95f66e764c2c11f2df422ae879d467ff41dae657fe5447a1aeef4fcfe9b781a"
    sha256 cellar: :any_skip_relocation, big_sur:      "e0b5f2f8f31a9ed0bcc293159c2a0be5aa85fc1b1ac1124edfbbfa7c7364f673"
    sha256 cellar: :any_skip_relocation, catalina:     "d0a5e819464c8260e6bd809fb86165b384212141af8c25427f23a9bc3d68f5c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8e01b2d90970cb66721cf5f5e5135a7867112fe6239250ea2b0cc5eeebb4f33e"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build
  depends_on "node" => :build

  # stack/ghc currently have a number of issues building for aarch64
  # https://github.com/unisonweb/unison/issues/3136
  depends_on arch: :x86_64

  uses_from_macos "xz" => :build
  uses_from_macos "zlib"

  resource "codebase-ui" do
    url "https://github.com/unisonweb/codebase-ui/archive/refs/tags/release/M3.tar.gz"
    sha256 "84be9135a821615f8fc73a0a894aa46a11c55393c43dc26e16a5ce75f8063012"
    version "M3"
  end

  def install
    jobs = ENV.make_jobs
    ENV.deparallelize

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

    # Build and install the web interface
    resource("codebase-ui").stage do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"

      prefix.install "dist/unisonLocal" => "ui"
    end
  end

  test do
    # Ensure the codebase-ui version matches the ucm version
    assert_equal version, resource("codebase-ui").version

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
