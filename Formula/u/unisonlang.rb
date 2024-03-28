require "language/node"

class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  license "MIT"

  stable do
    url "https://github.com/unisonweb/unison.git",
        tag:      "release/M5j",
        revision: "7778bdc1a1e97e82a6ae3910a7ed10074297ff27"
    version "M5j"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/M5j.tar.gz"
      version "M5j"
      sha256 "99f8dd4c86b1cae263f16b2e04ace88764a8a1b138cead4756ceaadb7899c338"
    end
  end

  livecheck do
    url :stable
    regex(%r{^release/(M\d+[a-z]*)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27ab477693638d1b62c7b679ad24dddf5ea6bd0745d8ff03c0da85d8c4560d5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ca8bfe440d39d66d88e2d436d8ad374393963737fd8a7d0a4e53a37758d8aa7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d772b22156d824974696caf89ea263f125a62cd8eb0d8a4cab2c07f710efe14f"
    sha256 cellar: :any_skip_relocation, sonoma:         "77d8a6b34336d5c63564877a8a6dd97a855a3edef5a3926adbaba5d5fbdb5aa1"
    sha256 cellar: :any_skip_relocation, ventura:        "24d03a539050feb1aefe0ebbecef1c4f06f2379d91a063ea144af02dc3f94f45"
    sha256 cellar: :any_skip_relocation, monterey:       "2de0f07799a44b4d53619f62b20741dfa12040fb90fcab8421a8564c5006d5ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d594aae90116a8136956555221276bd192bccd2155c64b71cface577c8f5d981"
  end

  head do
    url "https://github.com/unisonweb/unison.git", branch: "trunk"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui.git", branch: "main"
    end
  end

  depends_on "ghc@9.2" => :build # GHC 9.4 PR: https://github.com/unisonweb/unison/pull/4009
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

  def install
    odie "local-ui resource needs to be updated" if build.stable? && version != resource("local-ui").version

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
