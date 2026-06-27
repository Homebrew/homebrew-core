class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://github.com/goplus/xgo/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "fa3ebdea43b05a5542a62801eeb19cf27a718cdb57ea7fb56f957e81afce6f66"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "34872fe964255a0bd866b07167c04818a36872aad10ba2115e8f2614198888f6"
    sha256 arm64_sequoia: "34872fe964255a0bd866b07167c04818a36872aad10ba2115e8f2614198888f6"
    sha256 arm64_sonoma:  "34872fe964255a0bd866b07167c04818a36872aad10ba2115e8f2614198888f6"
    sha256 sonoma:        "23a6c67db420f877223d50e3206d818781be809ee644e3b0da0a11a62248ef40"
    sha256 arm64_linux:   "a0874fd9ac6c1c1e748aedc906f5d79b8a0db4476149b2ea8c1606389f6ee949"
    sha256 x86_64_linux:  "84ce8fb0ec6bb69cb288b44c1fb396663c34ce267b8880446e0ee11872ee482b"
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
