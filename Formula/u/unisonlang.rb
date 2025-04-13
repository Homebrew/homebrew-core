class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  license "MIT"

  stable do
    url "https://github.com/unisonweb/unison.git",
        tag:      "release/0.5.37",
        revision: "51d6d80ead4325a5d491a795a413b82d4af6d35a"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/0.5.37.tar.gz"
      sha256 "2095a3e28e06971fc3da91e85c3011b37e9f8dfb6e452138c1d075dd473efe63"

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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d282e3226c03e85bd3403111f63072a20b6a7edb6b242c482c46cf59dff9e79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6fa4e920f356f33d4bc3c06af6ba7cd99e2aae9c632a739f1e26b459efb91cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6445157b33bb5ef1f266916d5b29cd14ede7a2c8add7116490ba480e6498af3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "37835d20837a503e45b37e309f92052a4ec9b6a892a54c6dd71a706362b7cf66"
    sha256 cellar: :any_skip_relocation, ventura:       "d2d5592b3c455b9bd93c6c7ab2b0d93659263c7b31cc0e69329a75a5c62c3109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caa5eadf8d96ceade67ce8c74072e1e7b00cb920def68c448b705ff4065e42c4"
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
