class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://github.com/goplus/xgo/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "50e588653f0bbac730d561ef06b0d4c1baba441c72beb37ab6c046ff865bcbcc"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "48f6c5b8edaca86cbe7ba51b7a63c99e7c15c3cc5ee53ad0ecd454fb8d9e49b1"
    sha256 arm64_sequoia: "672d551ff8bc7b122b61843078ebbaae78e4445f1de8bbe67155f17f5e5d741e"
    sha256 arm64_sonoma:  "e7e20a80045614efde22eb0fc1b1440ab248c92087e13747b9d43c8f7b5942dd"
    sha256 sonoma:        "feb885a3091c946c01451c541fa99603d2a1a07b1de15eebe29a83d710eaaf91"
    sha256 arm64_linux:   "8f0da043453857b7548ce56b1b5a7c7a929a71e838794058a165b5a27228e973"
    sha256 x86_64_linux:  "d037a6ad4439b2a4f5263c7648e21fb8f97e0b41454f849c0fe5a65eb18c3999"
  end

  depends_on "go"

  def install
    ENV["GOPROOT_FINAL"] = libexec

    # Add VERSION file
    (buildpath/"VERSION").write version

    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
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
