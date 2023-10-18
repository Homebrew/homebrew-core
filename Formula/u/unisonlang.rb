require "language/node"

class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  url "https://github.com/unisonweb/unison.git",
      tag:      "release/M5f",
      revision: "04ba01c6372c5b9ddf64d985b649e05313ca5947"
  version "M5f"
  license "MIT"
  head "https://github.com/unisonweb/unison.git", branch: "trunk"

  livecheck do
    url :stable
    regex(%r{^release/(M\d+[a-z]*)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47a5327b2e9356d82a7a0c581f5be6d6269f8b8a10c0b7196696f1774a18e53b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbd8a5fe611dfd9f61e4110fbef149787fa705275512609f77b8fe40017fd234"
    sha256 cellar: :any_skip_relocation, ventura:        "bf4c489e1f7ed9756710fb621b10b12bb26e60a8a76cc875443ca0b7fac429fe"
    sha256 cellar: :any_skip_relocation, monterey:       "3f062f42e82d5186ed533e5973bb4f111ddf6243f7c8b2931d3661d70c08daea"
    sha256 cellar: :any_skip_relocation, big_sur:        "8089a855ed40041e818a99af9b2c4a3187db2eb68936e6b7628bbc8152cc37f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2fb2da2b4a3940763e250042884dc564a3dc527da842f3213e79be1aa6ef811"
  end

  depends_on "ghc@9.2" => :build
  depends_on "haskell-stack" => :build
  depends_on "node@18" => :build

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
    url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/M5f.tar.gz"
    version "M5f"
    sha256 "26becc00486f1574b14d86452b3e1f45b3361af009c576d3a17b0cb518a07191"
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
