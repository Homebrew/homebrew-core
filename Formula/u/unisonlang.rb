class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  license "MIT"

  stable do
    url "https://github.com/unisonweb/unison/archive/refs/tags/release/1.4.0.tar.gz"
    sha256 "43fd81354afd6f16adefb6beda6bb06f3df853ba74cf0ae3e85baa4018c22b31"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/1.4.0.tar.gz"
      sha256 "36e5b24d4e9836b5b7bb52669fcd59bc5a952777c8a69c5136a61e606fa08a13"

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
    sha256 cellar: :any, arm64_tahoe:   "e1b182aaa2007527105a98e8d11683fe393902fb51e07ce9b8c09d36db70ad7f"
    sha256 cellar: :any, arm64_sequoia: "a788df11b94caf5e1dc7aca9d27a4ea55d3ad7b2815de476a93a5482737016e9"
    sha256 cellar: :any, arm64_sonoma:  "d6c410157b80a751527439ca540d77ab4847c6a4e177b6b61480b703b6540a95"
    sha256 cellar: :any, sonoma:        "e4dfacde76d8a10d1bbe5bf6822cc3d5aeff21345e797c336420102fc1ea7710"
    sha256 cellar: :any, arm64_linux:   "02f273b7190cb560122167ae28f46844e7481fcec589c21b7c70d78e1d552e93"
    sha256 cellar: :any, x86_64_linux:  "b2748c470b5e364faac2d2322da18e478357a0232d12d93024b503367ade718a"
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
  depends_on "pkgconf" => :build
  depends_on "libyaml"

  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build
  uses_from_macos "sqlite"

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
      --flag=direct-sqlite:systemlib
      --flag=libyaml:system-libyaml
      --flag=persistent-sqlite:systemlib
      --flag=persistent-sqlite:use-pkgconfig
      --jobs=#{jobs}
      --local-bin-path=#{prefix}
      --no-install-ghc
      --skip-ghc-check
      --system-ghc
    ]
    if OS.linux?
      stack_args << "--ghc-options=-pie"

      # Using global configuration to apply options to all dependencies
      Pathname("#{Dir.home}/.stack/config.yaml").write <<~YAML
        ghc-options:
          "$everything": -split-sections -fPIC -fexternal-dynamic-refs
      YAML
    end

    system "stack", "install", *stack_args
    bin.install_symlink prefix/"unison" => "ucm"
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
