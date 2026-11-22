class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  license "MIT"

  stable do
    url "https://github.com/unisonweb/unison/archive/refs/tags/release/2.0.2.tar.gz"
    sha256 "b8ee1754ccaafd67d7d069edd536ad9d64cfae24a85b4c38b04d116c11b78dc9"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/2.0.2.tar.gz"
      sha256 "7eae3d82cd5a8508015848f85e0bb1576e652d84b56e988fbf93a6f43decfb04"

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
    manifest_sha256 "adc4ba09d64e1d1029e8a524ad9c724b1ade6ba93b47c3f7597cb4c966845ff9"
    sha256               arm64_golden_gate: "13bc88d12b7511ae21e9c6cda39a9e46677ea02bfd0057a40ce0550b5de5f215"
    sha256               arm64_tahoe:       "7f79f66856886d951ca5c8518164c6627a89b3231190cc70b3fd8b5f55841ddf"
    sha256               arm64_sequoia:     "d5dea5c3babfc5d1797969c2704031af04cd879cb5d24732114388cee731ca01"
    sha256 cellar: :any, arm64_linux:       "6c39e8aa727507e44999c69185dae1c03579a91aaac3efe9a4079fe2e7fe97e0"
    sha256 cellar: :any, x86_64_linux:      "f15a0bc0834b1fd573dd7b80a285cd0891657d4aa9555048084d1e03313b4a4b"
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
