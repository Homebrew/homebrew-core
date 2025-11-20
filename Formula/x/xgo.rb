class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://github.com/goplus/xgo/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "68ef472acd5853f69d5378845d92619c51834a637092e2bf0924ad1cea2dd1ac"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "0d2439d10b2769a8ca3b81cacf494e9fd98596b99d29e6cac83901e2c5fefe3c"
    sha256 arm64_sequoia: "4004acc7824bea575549e73756fc5918629db7a38d6654927809a16b6ef8eaac"
    sha256 arm64_sonoma:  "4ef69fb9a842f7666c6c62eb4a4fc677ec44b0daf1fadcb977c9946d274a74ce"
    sha256 sonoma:        "cc3f7445ca52dfd59501eba5223fd7265b9bc2e66891387d97ba1a00e70f0010"
    sha256 arm64_linux:   "35c47421c795df91c1eb0a104570f489569037f29195a04f2bbe488a2a9a487d"
    sha256 x86_64_linux:  "d2aa92ae84fae8c0819461437a377e33527e8e8632333b0c80004d4b8f3d6b05"
  end

  depends_on "go"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    bin.install_symlink Dir[libexec/"bin/*"]

    generate_completions_from_executable(bin/"xgo", "completion")
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
