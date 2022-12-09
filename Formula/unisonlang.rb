require "language/node"

class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  url "https://github.com/unisonweb/unison.git",
      tag:      "release/M4e",
      revision: "af0bc1325918c077fc62f9a7d2c3937d36d53563"
  version "M4e"
  license "MIT"
  head "https://github.com/unisonweb/unison.git", branch: "trunk"

  livecheck do
    url :stable
    regex(%r{^release/(M\d+[a-z]*)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3383767c375c4ed4cd435ada8ad1a41c3a37caa0b5862ba0e87146bc17469e16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a038983ab8e47486759ab05c768457e7c70938db34d65e20d03070e39e2f7b62"
    sha256 cellar: :any_skip_relocation, ventura:        "5ddfbca2b562432ef38cb34b0d06862ec9d1add35dde8445114bff0b735322c8"
    sha256 cellar: :any_skip_relocation, monterey:       "38e235af4c9ec469bdc8b3030ae61ef490d84a0133a3f0827606ebb2d4dc9944"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ffaf5bba561b915bcf2cddb4e151f5b3d3ee99ff6a01df494a099797e96e34d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e769988727a8c2b57802d92eedf7126acad0e085972e8b60a05860cd6dba2270"
  end

  depends_on "ghc@8.10" => :build
  depends_on "haskell-stack" => :build
  depends_on "node@18" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build
  uses_from_macos "zlib"

  resource "local-ui" do
    url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/M4e.tar.gz"
    sha256 "9caf016902a334db1109fd51c0aceaf7f64645201d1f1c44f45e7aaf9fd2a3d3"
    version "M4e"
  end

  resource "elm-git-install" do
    url "https://registry.npmjs.org/elm-git-install/-/elm-git-install-0.1.4.tgz"
    sha256 "f963ad9f8cc0d87c249cf8e63a62f648e3a3dd53ef658915c0062b2c27a11eeb"
  end

  resource "elm-json" do
    url "https://github.com/zwilias/elm-json/archive/refs/tags/v0.2.13.tar.gz"
    sha256 "8a6737e85e0a08ec3cc7de9efde3cf525fe0f0c3e7e5bb23796864edb09f31bc"
  end

  def install
    ENV["RUST_BACKTRACE"] = "1"
    resource("elm-git-install").stage do
      system "npm", "install", *Language::Node.std_npm_install_args(buildpath/"homebrew")
    end
    resource("elm-json").stage do
      system "cargo", "install", *std_cargo_args(root: buildpath/"homebrew"), "--debug"
    end
    ENV.prepend_path "PATH", buildpath/"homebrew/bin"

    # Build and install the web interface
    resource("local-ui").stage do
      system "npm", "install", *Language::Node.local_npm_install_args

      # Manually run commands from `npm run ui-core:install`
      Timeout.timeout(60) do
        system "elm-git-install"
      end
      uicore = JSON.parse(File.read("elm-stuff/gitdeps/github.com/unisonweb/ui-core/elm.json"))
      uicore["dependencies"].each do |name, version_range|
        Timeout.timeout(60) do
          system "elm-json", "-v", "-v", "-v", "install", "--yes", "#{name}@#{version_range.split(".")[0]}"
        end
      end

      system "npm", "run", "build"
      prefix.install "dist/unisonLocal" => "ui"
    end

    jobs = ENV.make_jobs
    ENV.deparallelize

    stack_args = %W[
      -v
      --system-ghc
      --no-install-ghc
      --skip-ghc-check
      --copy-bins
      --local-bin-path=#{buildpath}
    ]
    system "stack", "-j#{jobs}", "build", "--flag", "unison-parser-typechecker:optimized", *stack_args

    prefix.install "unison" => "ucm"
    bin.install_symlink prefix/"ucm"
  end

  test do
    # Ensure the local-ui version matches the ucm version
    assert_equal version, resource("local-ui").version

    # Initialize a codebase by starting the server/repl, but then run the "exit" command
    # once everything is set up.
    pipe_output("#{bin}/ucm -C ./", "exit")

    (testpath/"hello.u").write <<~EOS
      helloTo : Text ->{IO, Exception} ()
      helloTo name =
        printLine ("Hello " ++ name)

      hello : '{IO, Exception} ()
      hello _ =
        helloTo "Homebrew"
    EOS

    assert_match "Hello Homebrew", shell_output("#{bin}/ucm -C ./ run.file ./hello.u hello")
  end
end
