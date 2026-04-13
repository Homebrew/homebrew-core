class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://github.com/goplus/xgo/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "f77b147878140d99ea6d41e8f01287f629d44ed12fe6ed9a5477ee901fa7c0c9"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "c24e30cafeb875ab79dddef25bf41eda8d6ec2ecaabdf9404b79981e846f9ca1"
    sha256 arm64_sequoia: "c24e30cafeb875ab79dddef25bf41eda8d6ec2ecaabdf9404b79981e846f9ca1"
    sha256 arm64_sonoma:  "c24e30cafeb875ab79dddef25bf41eda8d6ec2ecaabdf9404b79981e846f9ca1"
    sha256 sonoma:        "a5c31aefba57e46587dbe415ef997b8b5c63ef3c79a1d4c9ce9e949df2db020d"
    sha256 arm64_linux:   "5c0f933eac159d7cebfc63740c5a5d17026f6aab7446f82023160d88bdbc7883"
    sha256 x86_64_linux:  "52edd8693fe6bf0629b000f64a86e2d066566b75c39a71249af65960f99add0c"
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
