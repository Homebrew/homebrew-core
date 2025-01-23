class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  license "MIT"

  stable do
    url "https://github.com/unisonweb/unison.git",
        tag:      "release/0.5.32",
        revision: "d3dea937070606cca5be8c9f874943b8122db327"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/0.5.32.tar.gz"
      sha256 "69ed790cba455677e864467446791650271cf163fd7a2246e4c45eddb317dd13"

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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff20a6e33021a558826efc620fd942c33f6c37d4b24f68259ee27235029d65d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4249a0fd8346538ffb35240e69786a8e429573ecc87b746cf1d01867fc1d25f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9fc9d00e8931cbe593d89206728232e5dc262279c354ac4a0fa1c0198df06dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e9040aeffcc3bcce6bbdf3f9c003876ec36b9ca575daa772da85692b30e2d18"
    sha256 cellar: :any_skip_relocation, ventura:       "f14c6d1da1dcc2dcddd6938a437efc5a067c9efbdfc1c8196e0dc209825f2f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "251ff442ba8c3b83960da3bd37f5bb79385598e01ea4d19d5558c1f5144ee0c6"
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
  depends_on "node" => :build

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
