class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  license "MIT"

  stable do
    url "https://github.com/unisonweb/unison/archive/refs/tags/release/1.0.2.tar.gz"
    sha256 "e650cdf2eeb1cae806b4fcba8f08184c0b9541ae4a30274f212c3ce70ded1c7b"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/1.0.2.tar.gz"
      sha256 "50ad4aaa747b1386e94664c43895be0c9ee0d1033c2591ac4a500ec38786f422"

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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3aae7a4a17345d0b4f1bdbbbec23fc8819b7193169aba173c0d30faba3e81976"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7459ffed78adeb7128f9bcc18f51110940c17ab8e60dda2ab457a72f29662543"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c034d9a2dbafc1deffbc1cbde4042871de188f23b84c17d5877a7ce990efcdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dd296cd1ede59612ded78f434130abefab573684b866a03d92a6c3e89cabd7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b761941c1f16fc4cfd8d1ccc27291fda798778d91d9ece2ce382ae459ae54250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20fcf507875fadcca4f3a94c25688fab169da75e09efe258ac4924e8ce337147"
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
