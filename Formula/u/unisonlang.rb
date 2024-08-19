class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  license "MIT"

  stable do
    url "https://github.com/unisonweb/unison.git",
        tag:      "release/0.5.25",
        revision: "7301b693c8a9f9a8647de4e2b8f65e96cb3260b0"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/0.5.25.tar.gz"
      sha256 "04565fb26f7ba8367968f382ee20edaecda917c548a51a93ed7c69057f0796b7"
    end
  end

  livecheck do
    url :stable
    regex(%r{^release/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "588dfadbe6163e6deee17e080a4885a8174814cb709126d3c874b1cd1adbd200"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b707cf5713961b8d1b797654f9fbc876d24e4a25c91dd2085b35b670787ee395"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d19a8eab85219b6dc15a50fbbbd9d41068326480d9687269d42d3b665240c6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e59326ebe8e09b4baec2a67ee8d7766d9f8b485f404ba511cb5637894d88661b"
    sha256 cellar: :any_skip_relocation, ventura:        "997a0883fad382246f33ca204ecc6d6f05df74958cdcf85876f10e7874faab8b"
    sha256 cellar: :any_skip_relocation, monterey:       "2fabab188500a58f189a21cf64588160855e85db202e4d2df536ceb7e8f5da26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea921a1229683575fb6e5b8596d098beef8c7666a05b495a6f031da4a0ca14e2"
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
  depends_on "node@20" => :build

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

    system "stack", "-j#{jobs}", "build", "--flag", "unison-parser-typechecker:optimized", *stack_args

    prefix.install "unison" => "ucm"
    bin.install_symlink prefix/"ucm"
  end

  test do
    (testpath/"hello.u").write <<~EOS
      helloTo : Text ->{IO, Exception} ()
      helloTo name =
        printLine ("Hello " ++ name)

      hello : '{IO, Exception} ()
      hello _ =
        helloTo "Homebrew"
    EOS

    (testpath/"hello.md").write <<~EOS
      ```ucm
      scratch/main> project.create test
      test/main> load hello.u
      test/main> add
      test/main> run hello
      ```
    EOS

    assert_match "Hello Homebrew", shell_output("#{bin}/ucm --codebase-create ./ transcript.fork hello.md")
  end
end
