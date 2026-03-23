class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://github.com/goplus/xgo/archive/refs/tags/v1.6.7.tar.gz"
  sha256 "5f9bccf5bd1ef91d3d088db11a05f153ad3c1ac01842388ec84ea9c733741d56"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "855cdd9fc010962d9f2b1d90a0f34fe7654ac4b1603cc52a11482c45f43fc451"
    sha256 arm64_sequoia: "855cdd9fc010962d9f2b1d90a0f34fe7654ac4b1603cc52a11482c45f43fc451"
    sha256 arm64_sonoma:  "855cdd9fc010962d9f2b1d90a0f34fe7654ac4b1603cc52a11482c45f43fc451"
    sha256 sonoma:        "d1517d3b9955f63206babdea7e77ba51af0310b36754e767dfc2fa4fc6f93ea8"
    sha256 arm64_linux:   "e6f878c43f826b8b197f2a7bef8d071cdad1ddf1e35065fca7f70f0021b18c4d"
    sha256 x86_64_linux:  "4bc8d5d8e0721e0642a5b919cca4ca7567e2db8220e89ee23a06bf1e87e91b6e"
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
