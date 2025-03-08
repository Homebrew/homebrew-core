class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  license "MIT"

  stable do
    url "https://github.com/unisonweb/unison.git",
        tag:      "release/0.5.36",
        revision: "196abd1b2a320c542ddf2ffac5bcdc9178f0b1d1"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/0.5.36.tar.gz"
      sha256 "2f95a3e07f797abad87bfdc49976f030fca5a9b53952c2d9adc8947ce56cfd1b"

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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8934c751814b72a24b6584a669c8f19fef4c640fe37b7080f2e1f8bb03d24abc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7716d3f47a4e9dd9bcc1429b15f685c710ef9ca067103e072d846e091ea7a700"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00541df7981fd93f94e225ae363cbef114f3dca6164c72606f70c7973f6e655e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c279d535cf2a0a8809d741a2f235d8ebebb5e5e9df656c3e4ab2fe7e4709cc84"
    sha256 cellar: :any_skip_relocation, ventura:       "c57ee9ec0c1c0170eb0e36d74518d0c568a8031f48f34786b75987347f8dfdf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fedf3283314aef76c384c70949c0b2f9c241c5f5425598527f758f4621571e6"
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
