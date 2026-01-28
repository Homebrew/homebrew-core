class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://github.com/goplus/xgo/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "dcf30d21ce67fec0799579d689a783bbe94b8f53cf1b28ffa652ced058740ab9"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "7097581244a41cf22cc95318f63c8855f74cef9bbb32158df3931514c2ef21c1"
    sha256 arm64_sequoia: "8ec0abcc6aa2362dbf1770246b19724837e81b53261f10faeef1a02cb44e4069"
    sha256 arm64_sonoma:  "427d94a1e53ac3d7fd4915ce3e2bca1b8c896a561a32509c1e9545d8d261cf8c"
    sha256 sonoma:        "29287538c63681b8e7bf32266957c572fc91cc5af9990ee90e715747a641b1ab"
    sha256 arm64_linux:   "a99aa81e211c651dcf7609df0260f6b3c3a38c8587a09634d2926ddc379e7cb6"
    sha256 x86_64_linux:  "85d219cdcc89bf8b9d5993463f810ef37a6d87d9dad3d595da49174a10ed67e0"
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
