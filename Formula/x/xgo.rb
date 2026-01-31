class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://github.com/goplus/xgo/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "1fa550a9bea9abfe78d4726c9bc173bc7a2e83a2a77fad450294325331801543"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "327de65a0450f47147acc99afc5cfdc5a3d407499d2d506dbd37de896fc1528c"
    sha256 arm64_sequoia: "82b88f964aefc2670e17d2923bdec93abd21b96a7c4f2adffc6c9116ba4804e9"
    sha256 arm64_sonoma:  "6849838d45583087b52e52675d8d38670169846965ec2c9cf3fe5e475e877cd3"
    sha256 sonoma:        "c84da9b00f830dcae41a3d188246975444ae4e75500f83138ddfeeac51d4c6f9"
    sha256 arm64_linux:   "d2814a297dcd979f2b9291d6ab818a8032fee8cf54e24a6aab6ef93782b32f65"
    sha256 x86_64_linux:  "6252ca4b94116631284441dea700dd25ba2875b89f37dc6397fc4e440763c4e9"
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
