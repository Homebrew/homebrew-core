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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0c302234a571e854f87b61e1eb685fad5085477daa33a6f7a0e5ae33dae10c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc86bc0378aaf9a9f97c24fb4efb03ab0cd159f963d34935ec97c48d6035a43c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1843ed7d7646cd8eed9c602b0e5e042d50cdc4f2dc0b33decac3adee5e658787"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f7e75c91567d955e142ee14517bab99a2af38f66f316845df8a3425e48890d1"
    sha256 cellar: :any,                 arm64_linux:   "546d69182075bbb4be348028e5b26155f7b3100275f1b863c18fb4c38e7a51b3"
    sha256 cellar: :any,                 x86_64_linux:  "569b34b258ba310c2589f7728ca4fdfb3d7bac148647592e0805fee8ac1eb711"
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

      # Loosen the elm-version range to compatible versions as we are not using npm installed copy.
      inreplace "elm.json", /"elm-version": "[0-9.]+"/, "\"elm-version\": \"#{Formula["elm"].version}\""

      system "npm", "install", *std_npm_args(prefix: false)
      # Install missing peer dependencies
      system "npm", "install", *std_npm_args(prefix: false), "favicons"

      # Wire the real binaries into node_modules
      ln_sf formula_opt_bin("elm")/"elm", "node_modules/elm/bin/elm"
      ln_sf formula_opt_bin("elm-format")/"elm-format", "node_modules/elm-format/bin/elm-format"

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
      --copy-bins
      --local-bin-path=#{buildpath}
      --no-install-ghc
      --skip-ghc-check
      --system-ghc
    ]
    stack_args << "--ghc-options=-pie" if OS.linux? && Hardware::CPU.arm?

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
