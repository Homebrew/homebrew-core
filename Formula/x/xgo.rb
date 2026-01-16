class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://github.com/goplus/xgo/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "af10b9e8d3980e4c4f4b9bf3d341e3d1dd72d1324ca26825b360c3ce865b7da0"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "db22007b23ef06d4484c60b697d6045966001f6077aefc12ab33c3569794113a"
    sha256 arm64_sequoia: "f3c8351706da49467a02b816225a37b0dee6fd5ef7f00e9e6d3562e25dec7565"
    sha256 arm64_sonoma:  "0112b7fdc299819e902b81588d4de6be6c298f98848b178e7b83aecd3441d843"
    sha256 sonoma:        "8e0c261e9093f9070da88e1d97b30a56170976266a4f12638df238846ce072a5"
    sha256 arm64_linux:   "1d2ad096a30f1f54186ee5f324688f580f2749a68254f35bfbfda767abd2a3ed"
    sha256 x86_64_linux:  "59b8e2ead8b18c27e3dd72206d909bbffce49213c5b9552607db7a50c36212cd"
  end

  depends_on "go"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    bin.install_symlink Dir[libexec/"bin/*"]

    generate_completions_from_executable(bin/"xgo", shell_parameter_format: :cobra)
  end

  test do
    system bin/"xgo", "mod", "init", "hello"
    (testpath/"hello.xgo").write <<~XGO
      println("Hello World")
    XGO

    # Run xgo fmt, run, build
    assert_equal "v#{version}", shell_output("#{bin}/xgo env XGOVERSION").chomp
    system bin/"xgo", "fmt", "hello.xgo"
    assert_equal "Hello World\n", shell_output("#{bin}/xgo run hello.xgo 2>&1")
    system bin/"xgo", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output("./hello 2>&1")
  end
end
