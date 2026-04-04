class Rad < Formula
  desc "Modern CLI scripts made easy"
  homepage "https://amterp.github.io/rad/"
  url "https://github.com/amterp/rad/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "7d2215d596fdb6d380761411bf868b7cd451a436efa6dd2153265a7b981e14d2"
  license "Apache-2.0"
  head "https://github.com/amterp/rad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2dc9e35ceee7326e0362ff3ba57263616c34de43d0a03fec36de1a6ec49cbf97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01d550b426abceb361865185e7be008a67a9fb0fac141baa95960ecd1b2bfa92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "077f3f9c45c5060d48fd7747531839b432d613d195e242a86fb46371423da232"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a9e5b35aeafaeafce5e53572c6bc38247af98520dc04f3c3402a9aa690e162a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "107605a7cfd3a13e4defcd762386cb7aa5670e6c641b2b3149e1c27ec40843da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baa5659342010df7ab5f889e3c386f3571875f23be7097f8bf86b4cde2186523"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rad --version")

    (testpath/"test").write <<~SHELL
      #!/usr/bin/env rad

      args:
          times int = 1

      for _ in range(times):
          print("Hello, Homebrew!")
    SHELL
    chmod "+x", testpath/"test"

    assert_match "Hello, Homebrew!\nHello, Homebrew!", shell_output("#{testpath}/test 2")
  end
end
