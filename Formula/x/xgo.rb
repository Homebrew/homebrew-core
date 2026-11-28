class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://github.com/goplus/xgo/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "f32d699348a7f549787941506060f9e217c160d4f0db683bde24866df2e4a9ff"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "d0372b98b2ef09bf6174a38d656f09cb4fa62d74a6c2712d3a58d5e49c2295b7"
    sha256 arm64_golden_gate: "d543f9354bef593b320c521b027c74798747eac5bae9359b39ef34a29b47b21c"
    sha256 arm64_tahoe:       "d543f9354bef593b320c521b027c74798747eac5bae9359b39ef34a29b47b21c"
    sha256 arm64_sequoia:     "d543f9354bef593b320c521b027c74798747eac5bae9359b39ef34a29b47b21c"
    sha256 arm64_linux:       "839fcdc4e66e5d0e811e6a7437a88036b869fc8971283de2e18390393d3bc42e"
    sha256 x86_64_linux:      "724e48ada069250018fd3745d07e282f65a1e145e644947ecdb8543c4d181fd5"
  end

  depends_on "go"

  deny_network_access!

  def fetch
    cd "cmd" do
      system "go", "mod", "download"
    end
  end

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -X github.com/goplus/xgo/env.buildVersion=v#{version}
      -X github.com/goplus/xgo/env.buildDate=#{time.strftime("%Y-%m-%d")}
      -X github.com/goplus/xgo/env.defaultXGoRoot=#{libexec}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:, output: libexec/"bin/xgo"), "./xgo"
    end

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
