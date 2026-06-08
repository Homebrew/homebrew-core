class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://github.com/goplus/xgo/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "be369106bea43407da81390e82db6a9fa9afb5c3483a64d9664360369ce7d164"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "8aadc479dd02a62514474dcd6248c5c8b5b5b4e7fb781749075dfc59b17bd12c"
    sha256 arm64_sequoia: "8aadc479dd02a62514474dcd6248c5c8b5b5b4e7fb781749075dfc59b17bd12c"
    sha256 arm64_sonoma:  "8aadc479dd02a62514474dcd6248c5c8b5b5b4e7fb781749075dfc59b17bd12c"
    sha256 sonoma:        "353a2a51d49829c56e921e6b9913de95239856f89d9658b697d791706a549f7c"
    sha256 arm64_linux:   "c7b7afed9020e00ac494fc1e20dcb98b7556783c6e1b1af376a343ba32c67d63"
    sha256 x86_64_linux:  "78cb9e42794ae1effea396ba1f173a1c55dbe2e8a1b578a357da6bd513b47c4b"
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
