class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  license "MIT"

  stable do
    url "https://github.com/unisonweb/unison.git",
        tag:      "release/0.5.47",
        revision: "e1b98c8608fcce3c79c8e09f9d3e507175c9ac56"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/0.5.47.tar.gz"
      sha256 "53a4d24bdae8c6c783b92b73d1bd49b066aa1b5b9d609e0cf9f824aa1e27a6ef"

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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "894922fbd79344551515897d6a64ee753e2ed856c6992b2d074ee0c168234a13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4172a6a3ea7007295c9a55ad51305e5ba49b5fd935309e6443e220bdcff7b9c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5156e037b3bc7d637e1abbdecca7434bb177535ccacabae942fc26bf441f657"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4618c4b9c08fb4905d2bc749a194e147f92e46d2cd2b1998862101fe5b8b72d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7e9ff640a1422f22e33bcb18ef9a32c0345aa838554779ca7168f74b681e57b"
    sha256 cellar: :any_skip_relocation, ventura:       "cb34e67c3af5d2b5f51a73ad417ce4d0b13c4b678fa3d3d0a181da9326bd848e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bc335144c76d77daa3a437f9b7c04128b3f4f1f0289f0b72ac1bad4ce67bf2a"
  end

  head do
    url "https://github.com/unisonweb/unison.git", branch: "trunk"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui.git", branch: "main"
    end
  end

  depends_on "elm" => :build
  depends_on "elm-format" => :build
  depends_on "ghc@9.6" => :build
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
      with_env(npm_config_ignore_scripts: "elm,elm-format") do
        system "npm", "install", *std_npm_args(prefix: false)
      end

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
