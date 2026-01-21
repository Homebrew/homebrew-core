class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://github.com/goplus/xgo/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "11b2389f189d74843b441f4fc9ebcbb36b0ee5e3787e72db5189af8de2f6b39b"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "ad6de52a7d5b1b92e28ece0862b2a30ae4b53ef7180453bb978d47c140ec5c89"
    sha256 arm64_sequoia: "89829f4ba6c8c672bfcf93029dc24661ee155992797855f7c2c2f1d759ed0432"
    sha256 arm64_sonoma:  "33356d6cd6689dc575494b9f616ffb448ec78cb1b74e2322852a082e251c129d"
    sha256 sonoma:        "bbbebea6974cddcbfe09ce9a8065c8b8fb4ccfbf4dc95a4c7669b221eb6e844d"
    sha256 arm64_linux:   "36d46f19056c9b22d74f54689f9729dceef67f6661d761cf03a429981af09082"
    sha256 x86_64_linux:  "a817cb61d77ac1dce4b37c0845ce3075b252268cbf4ff33937f7f284b83c2df9"
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
