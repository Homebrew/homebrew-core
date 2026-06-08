class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  license "MIT"

  stable do
    url "https://github.com/unisonweb/unison/archive/refs/tags/release/1.3.0.tar.gz"
    sha256 "9a9c53fcb7a6913504d3356b5661eae33c28271d6253fd5cb08cb5e93bd67295"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/1.3.0.tar.gz"
      sha256 "80e097c82b6a38f16d3c3b42463c331e3e63f4d39f4360d894c82dd447237bee"

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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50b548317e8ae9e4b68c46c38476e07c1dbdcd79b90b05632a2794f734371ae4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "101a75f0f7a0bfa4610de3d805d77ffc5ead27f8ed4ef28abc681adec545d30f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81d6f282fb3efd78061596c0720b2af8e15cfb5f3e9de3e335788c47d615453d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b801fe79e52ef7161d77e896fd68dcd42ee49ce04e32c9893cbf2b8124ef8757"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86fafa0dd2cec4f0869ad0f0694214f399209e48b8b7d2de8cf50fc3aed9a690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52e224fa610d3c36dbcc8d66145fb9b7e27b53d3918aca948667d76f228c6ebb"
  end

  head do
    url "https://github.com/unisonweb/unison.git", branch: "trunk"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui.git", branch: "main"
    end
  end

  depends_on "elm" => :build
  depends_on "elm-format" => :build
  depends_on "ghc@9.10" => :build
  depends_on "haskell-stack" => :build
  depends_on "node" => :build

  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
