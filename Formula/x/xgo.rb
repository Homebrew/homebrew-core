class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://github.com/goplus/xgo/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "838bb0a6145f7fd475908378adce274a6d5f7ee43ec78496738302aa89a1044a"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "d62b7759ab524d58fed0db26b9e246a57fba412b1e7202cf89e2e0cbbe01dc9c"
    sha256 arm64_sequoia: "02f42cc3c46799e6b809b50ceaa5512cafa6d8ff4e6ea4d744e98dd2e26e1fb5"
    sha256 arm64_sonoma:  "1e233953be33fe67c6fb3d679165d8370417042bdedad289e4af23bd24760994"
    sha256 arm64_ventura: "d0d0be86ca90cf721534a7c7b1d719dec6b03e551a940cbaee7f23c2e829cf8b"
    sha256 sonoma:        "6a7986efd5151bb42652b54860492f684a3ef91b475910a389c0cd3e354880fb"
    sha256 ventura:       "e7a4c9b41751832183092fe3b5e31b61d79103972fa2bd60ebc263b911936523"
    sha256 x86_64_linux:  "76579a5ada2ba8b925959bd8ae4a6ea62a3e63a32c6dad2225696e5f466e38e6"
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
