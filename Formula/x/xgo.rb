class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://github.com/goplus/xgo/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "aceb20c547645016b4feb33b7e32de79267f4796a0f26832d5b89e7329724afb"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "0a006c221de1b63e4e48fd0c93d54179c27bf14564a38e8f287a3eb4db406d21"
    sha256 arm64_sequoia: "0a006c221de1b63e4e48fd0c93d54179c27bf14564a38e8f287a3eb4db406d21"
    sha256 arm64_sonoma:  "0a006c221de1b63e4e48fd0c93d54179c27bf14564a38e8f287a3eb4db406d21"
    sha256 sonoma:        "996f11ba46e98229ad0af218246941442aadf3009de31e3216dcb39294a9cf8f"
    sha256 arm64_linux:   "13876585999db200c48d057e48fb2c899e0f927d65a6a323a88934d47df711c1"
    sha256 x86_64_linux:  "d82b76666a996113c29ee2ed4933e2fa5d90a6a4112d888028b88ebf303de600"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -X github.com/goplus/xgo/env.buildVersion=v#{version}
      -X github.com/goplus/xgo/env.buildDate=#{time.strftime("%Y-%m-%d")}
      -X github.com/goplus/xgo/env.defaultXGoRoot=#{libexec}
    ]

    system "go", "build", *std_go_args(ldflags:, output: libexec/"bin/xgo"), "./cmd/xgo"

    # gop is a symlink to xgo
    (libexec/"bin").install_symlink "xgo" => "gop"

    # Install source files (required for XGOROOT validation)
    libexec.install Dir["*"] - Dir[".*"] - ["bin"]
    bin.install_symlink Dir[libexec/"bin/*"]

    generate_completions_from_executable(bin/"xgo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xgo version")

    system bin/"xgo", "mod", "init", "hello"
    (testpath/"hello.xgo").write <<~XGO
      println("Hello World")
    XGO

    # Run xgo fmt, run, build
    system bin/"xgo", "fmt", "hello.xgo"
    assert_equal "Hello World\n", shell_output("#{bin}/xgo run hello.xgo 2>&1")
    system bin/"xgo", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output("./hello 2>&1")
  end
end
