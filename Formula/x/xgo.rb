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
    sha256 arm64_golden_gate: "c56d27f6491c0891b3fd069c360c284e558d07d1d57726569b887f44fdea439a"
    sha256 arm64_tahoe:       "c56d27f6491c0891b3fd069c360c284e558d07d1d57726569b887f44fdea439a"
    sha256 arm64_sequoia:     "c56d27f6491c0891b3fd069c360c284e558d07d1d57726569b887f44fdea439a"
    sha256 arm64_linux:       "14cea8b0af1fe0ca9dc77ad43c0981fffe01514c141d1e3fad6a9bb2054ffae6"
    sha256 x86_64_linux:      "1d6886dc54b972a45a883e370a6718c47e4adad41d3e34e81546989bc55cbbc1"
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
