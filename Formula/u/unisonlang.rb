class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  license "MIT"

  stable do
    url "https://github.com/unisonweb/unison/archive/refs/tags/release/1.1.0.tar.gz"
    sha256 "f776bc7f96f68a7f95ee91160a6641aba0d2f7bc6ef60d5cb4b2441474ce5a39"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/1.1.0.tar.gz"
      sha256 "45556af491e8c524a6bbc5aa130aba908f66805dd981f553ad3a6f7c0db7ae61"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :stable
    regex(%r{^release/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47a01b91d16c70c45f050360c3ed7e22c6ee2d4f651b76e63b8e834a507e8596"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b074c9dd7ab1d47fc52652bb813672921007fbefbb3198d3c923ba8a2f616dc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f2509463fb563729981497d3b6952d591da27cf78b7df41d815fa7416e10619"
    sha256 cellar: :any_skip_relocation, sonoma:        "f36866630790b6ab3b0ea79c5d039dd67644d50c19a6a032a411b7fec7192a5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5aa6e2c708d907d6b873f01b0b21a0ad6b0945e998b3e756f1371acb423d877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "490b67ce1c716a4dfda1e9a43c0e695970cfbfc6b5df6c072e38bea598a9d9ab"
  end

  head do
    url "https://github.com/unisonweb/unison.git", branch: "trunk"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui.git", branch: "main"
    end
  end

  depends_on "elm" => :build
  depends_on "elm-format" => :build
  depends_on "ghc@9.6" => :build # GHC 9.10 PR: https://github.com/unisonweb/unison/pull/6046
  depends_on "haskell-stack" => :build
  depends_on "node" => :build

  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build
  uses_from_macos "zlib"

  def install
    odie "local-ui resource needs to be updated" if build.stable? && version != resource("local-ui").version

    jobs = ENV.make_jobs
    ENV.deparallelize

    # Build and install the web interface
    resource("local-ui").stage do
      ENV["npm_config_ignore_scripts"] = "elm,elm-format"

      system "npm", "install", *std_npm_args(prefix: false)
      # Install missing peer dependencies
      system "npm", "install", *std_npm_args(prefix: false), "favicons"

      # Wire the real binaries into node_modules
      ln_sf Formula["elm"].opt_bin/"elm", "node_modules/elm/bin/elm"
      ln_sf Formula["elm-format"].opt_bin/"elm-format", "node_modules/elm-format/bin/elm-format"

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

    system "stack", "-j#{jobs}", "build", *stack_args

    prefix.install "unison" => "ucm"
    bin.install_symlink prefix/"ucm"
  end

  test do
    (testpath/"hello.u").write <<~UNISON
      helloTo : Text ->{IO, Exception} ()
      helloTo name =
        printLine ("Hello " ++ name)

      hello : '{IO, Exception} ()
      hello _ =
        helloTo "Homebrew"
    UNISON

    (testpath/"hello.md").write <<~MARKDOWN
      ```ucm
      scratch/main> project.create test
      test/main> load hello.u
      test/main> add
      test/main> run hello
      ```
    MARKDOWN

    assert_match "Hello Homebrew", shell_output("#{bin}/ucm --codebase-create ./ transcript.fork hello.md")
  end
end
