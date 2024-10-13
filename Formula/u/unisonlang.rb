class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  license "MIT"

  stable do
    url "https://github.com/unisonweb/unison.git",
        tag:      "release/0.5.27",
        revision: "bb3b5f1c9e9d11287906e8dea4ab186068b160ba"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/0.5.27.tar.gz"
      sha256 "eaefe430187f936f7af1a2052b7f4d4d3aaa81b11d3c2697e116b3de69373781"
    end
  end

  livecheck do
    url :stable
    regex(%r{^release/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c932ce73cc4a460b374a84658886fb0340f37fc57d3e29d26d8d3d71fd4c003e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef3a71e79da0bc262378436daee748db052a95562df7706d9b20917dbc8659fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9608de524d053b08952821a8f60135315f8cd6dc146b4fc02f1a4b8a69617343"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a7aca5dd9bdabcc1ad1dfccdbe797239f8288b995259fe2179141a1bc2c1790"
    sha256 cellar: :any_skip_relocation, ventura:       "4faa61a66721d02b8fe75094bff502a55701b3b91a2b84bceb72d9c4c521a609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "025cd5e87f536511ce28e66861da12c4d471fcfe5618959b74e45466af302ed3"
  end

  head do
    url "https://github.com/unisonweb/unison.git", branch: "trunk"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui.git", branch: "main"
    end
  end

  depends_on "elm" => :build
  depends_on "ghc@9.6" => :build
  depends_on "haskell-stack" => :build
  depends_on "node@20" => :build

  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "ncurses"
  end

  def install
    odie "local-ui resource needs to be updated" if build.stable? && version != resource("local-ui").version

    jobs = ENV.make_jobs
    ENV.deparallelize

    # Build and install the web interface
    resource("local-ui").stage do
      system "npm", "install", *std_npm_args(prefix: false)
      # Replace pre-built x86_64 elm binary
      elm = Pathname("node_modules/elm/bin/elm")
      elm.unlink
      elm.parent.install_symlink Formula["elm"].opt_bin/"elm"
      # HACK: Flaky command occasionally stalls build indefinitely so we force fail
      # if that occurs. Problem seems to happening while running `elm-json install`.
      # Issue ref: https://github.com/zwilias/elm-json/issues/50
      Timeout.timeout(300) do
        system "npm", "run", "ui-core-install"
      end
      system "npm", "run", "build"

      prefix.install "dist/unisonLocal" => "ui"
    end

    stack_args = %W[
      -v
      --system-ghc
      --no-install-ghc
      --skip-ghc-check
      --copy-bins
      --local-bin-path=#{buildpath}
    ]

    system "stack", "-j#{jobs}", "build", "--flag", "unison-parser-typechecker:optimized", *stack_args

    prefix.install "unison" => "ucm"
    bin.install_symlink prefix/"ucm"
  end

  test do
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
      scratch/main> project.create test
      test/main> load hello.u
      test/main> add
      test/main> run hello
      ```
    EOS

    assert_match "Hello Homebrew", shell_output("#{bin}/ucm --codebase-create ./ transcript.fork hello.md")
  end
end
