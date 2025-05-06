class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  license "MIT"

  stable do
    url "https://github.com/unisonweb/unison.git",
        tag:      "release/0.5.39",
        revision: "a56de2dc574aeb1ec0448092b94d6373e6cfb640"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/0.5.39.tar.gz"
      sha256 "8540afb233e1c99e25075ce443bf3529d401673f9f3d7d69bb8cddb63e1e82bb"

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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb17960289f828005b3e52a8a480d7a3e970e518400e2f55fef48a2a82d5c29e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ba2e858ec03679ade457ce9a5b6c846f56a7b8ba88a66d1b6645583afbc3696"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c05f19af063342403d8d207766f80fdf5d0ae51feb86f8462f784c6419c2d74"
    sha256 cellar: :any_skip_relocation, sonoma:        "29ea80a72604e450af13d35a11e77743d5fbd60be44a75203252e1d4bce48c4a"
    sha256 cellar: :any_skip_relocation, ventura:       "f843bc9fc8fcf1733eaa76e11ca8af3fb6e834d87ad45f1af00905d09f200a35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbdb44bfb2fcdc43ea61e410cc2586a785564ae66759b18d5ceae689f3dceb5f"
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
