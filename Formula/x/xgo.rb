class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://github.com/goplus/xgo/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "ec314d77477b62adb2c297931ad1cb4c1f197194a465209de81218ceebd6089b"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "0e4fd2f4eb245d182b44b646ba69c26ca149b1fc078a1b6cd3c535cf15ca8946"
    sha256 arm64_sequoia: "2c19011efb91f3364245e09820031e904b03454386b9a7fd51e50a7cb084b12d"
    sha256 arm64_sonoma:  "25a5409d2035a3c4cdf010ca9e0652ee945a489a0347cbeb26d18a4b7d79176f"
    sha256 sonoma:        "100f851b8c56238806a3a139e10259d3ea1706e8c087f49b57f0e2f097419922"
    sha256 arm64_linux:   "3fbf4ca8ce8214f8e3cc6442690c9182ab23fd66d8427e4eea2abf9ed5ee843c"
    sha256 x86_64_linux:  "9f0205adca4e42fc5c9f9a0265046766debcf98030987dde2fd2c5eeb411b797"
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
