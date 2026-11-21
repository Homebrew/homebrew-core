class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  license "MIT"

  stable do
    url "https://github.com/unisonweb/unison/archive/refs/tags/release/2.0.1.tar.gz"
    sha256 "a946203ef9b836f181d843406b42d62785e89fbcc3ba970cd61f960bda520aed"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/2.0.1.tar.gz"
      sha256 "0cec5f4bca59a4f9d52ec235784a3918f3ea5c23c9cb90e740bd9f0d9fce711d"

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
    manifest_sha256 "85d0e9870f6ff886bdadf2338047df2ca5e708abdb4fb5645eeb41c53ad50597"
    sha256               arm64_golden_gate: "8d4b362ced6d4834e53e7a25995ccf7e042eedc335b13458a2b42a7d3b57b70c"
    sha256               arm64_tahoe:       "d6e5f1bee9de6cb9446bcd508fe98825625bbd99de9cfdc6cd2848f0f5f3c509"
    sha256               arm64_sequoia:     "fa7b021f65cba1fabfb18ef40789981179588f33264f1b9999bad0249fefa039"
    sha256 cellar: :any, arm64_linux:       "c496c752d8aa65148b6120d98742b0f00c7e6b4a5ec124680a2fe88c14f8d94e"
    sha256 cellar: :any, x86_64_linux:      "fc154b199bffc22a76d3a8c888cb0b946ea7eb5470562a9e9dc7dc9b413981ca"
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
  depends_on "sqlite" # macOS sqlite lacks `sqlite3_enable_load_extension` used by `direct-sqlite`

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
      require "timeout"
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
    # `ghc@9.10`'s `rts` puts the SDK `usr/lib` on the library path, so search Homebrew `sqlite` first
    stack_args << "--extra-lib-dirs=#{formula_opt_lib("sqlite")}" if OS.mac?
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
