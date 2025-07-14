class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://github.com/goplus/xgo/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "e7d80a6760f794ffb4f30c89097b8903f8a1e8c6b60706673d88bcdc304f05c8"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "0723df7efa7eb8b185e22a6f5e9fa64657b7e7a878aa5a711ff7dd520d219729"
    sha256 arm64_sonoma:  "fa436983786f044a5903a0a60b05a87c58f328e3f1a532d9539c3225f6dfcc76"
    sha256 arm64_ventura: "dcf3557aed96b516020d24bb12d5a0520a7086ffb117b981692f92e8702e9cbb"
    sha256 sonoma:        "4cff7a89870c4874107f69583b80962df013db979c66154cf735d1bbd5aea096"
    sha256 ventura:       "3c597396d5c357fb3f0066c6b9a9ea641cb30a8c3e127f0eae2df4bddb990e08"
    sha256 x86_64_linux:  "a89f7cd3016928e0c6637257328ef0396c6eb9eec821e232f40dc80d2907de52"
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
