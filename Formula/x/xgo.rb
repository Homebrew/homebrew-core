class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://github.com/goplus/xgo/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "a5a5278e9806a11d0618c5a18b704754e559ef434eebae3ea9190481d866a96f"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "3d5bc393e4cce01f458e7b254e23eb01e84634fc2c0a57238ae6f52bf73eb04c"
    sha256 arm64_sequoia: "3d5bc393e4cce01f458e7b254e23eb01e84634fc2c0a57238ae6f52bf73eb04c"
    sha256 arm64_sonoma:  "3d5bc393e4cce01f458e7b254e23eb01e84634fc2c0a57238ae6f52bf73eb04c"
    sha256 sonoma:        "1f66ab14492171bd2b075e0b7d623111a82184c183ab7d77ca0885f16219b23e"
    sha256 arm64_linux:   "1bafb97ff8e503fe065b6811aec684677e36dc2d4a2471e7152696ea6ec8bef0"
    sha256 x86_64_linux:  "87dd24df2498716fd78e40409b4ced3d0abbb66b912c02e6c96e4cef03f374e5"
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
