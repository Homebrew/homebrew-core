class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.10.3.tar.gz"
  sha256 "db5e23fa5356f409c4b09fb37ad13985e404f4a4ad216a5e1b659d72322610c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f392d1f7b7a6d2732300786b195268671dcc72fe94b24ca0d58fa09c6907806f"
    sha256 cellar: :any_skip_relocation, big_sur:       "63309f2ad4c4113344df06b93c834f453bd1e25ee38e7b5f417800950e94a71a"
    sha256 cellar: :any_skip_relocation, catalina:      "43500d0981332bfc00573e647f8cc7ab05a338e64948153f06c20c3d52160704"
    sha256 cellar: :any_skip_relocation, mojave:        "0eab2f5b2a741f46dc8edb3f95bb6b57f5831c124f8e69fe983bf730efd6ded5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", "./cmd/vale"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~EOS
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    EOS

    (testpath/"vale.ini").write <<~EOS
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    EOS

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end
