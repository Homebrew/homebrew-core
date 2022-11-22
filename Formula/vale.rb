class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.21.1.tar.gz"
  sha256 "249667a6b12950b94236e6cb3cf776cc28e623d46bad03bb64e9db34d1f572fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27d683821f7a5eb81d1d0012ac1614bf859dd38e0fd9685ce06d3fe4d86cdf31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3c5228f5ecf08126dfd84d06d10e2acff7b0b7107d2c91baf9fd4342599980f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebe5362d9c38f17cadb6c5fb99ec3ebe2503de0a540d27cef9dcc3376c2bea71"
    sha256 cellar: :any_skip_relocation, ventura:        "fe37382882b6805f6006d236b3127ccac7d07f82a4e8f79fab535c170bab6bf0"
    sha256 cellar: :any_skip_relocation, monterey:       "95c632ae0103cc4ae6a9b163387dc7b694230a2df21a0016c1ef68afbc0848ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "0892053099645b0cbd8e28f8667d787f25caf3da4533942bfff75f389888552a"
    sha256 cellar: :any_skip_relocation, catalina:       "d02b773f6df9f9ff7b58f020572f33a76db66d4a43fe423d19a6fdcc56b8ba91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ea7d70ef93b427feae0206af8997cc7ed9711f4befe922924abbd66689577a3"
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
