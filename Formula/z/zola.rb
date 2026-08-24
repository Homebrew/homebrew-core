class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/refs/tags/v0.23.4.tar.gz"
  sha256 "b8eb945dbafe1e73f1601c215ef1563b9b0a25097576ba48f646db8d75568e40"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b107633dcee407e0b88cab7b663f6abf8062448f238e4407918ddae882ba641a"
    sha256 cellar: :any, arm64_sequoia: "e4179ad07943b7259c087fea1236045443514aae652475c54a1eba9b7a13be6f"
    sha256 cellar: :any, arm64_sonoma:  "cf6afb21f6dfa11137322899c5017b5b579b95294be71fef816c9c37c816c123"
    sha256 cellar: :any, sonoma:        "5fc35fbbaf45c462b2c52e5eebe830af6a1c8b498127f276825c47bdc5d6d294"
    sha256 cellar: :any, arm64_linux:   "f05951a7defe4afe529eeb75ffe9f027907a6f43970b2000786da8a67ac5256d"
    sha256 cellar: :any, x86_64_linux:  "eaf2128bafeeb4e3fedde18ca57f4c4c884e1b84f297583b1644a969883e40ff"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma" # for onig_sys

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zola", "completion")
  end

  test do
    system "yes '' | #{bin}/zola init mysite"
    (testpath/"mysite/content/blog/_index.md").write <<~MARKDOWN
      +++
      +++

      Hi I'm Homebrew.
    MARKDOWN
    (testpath/"mysite/templates/section.html").write <<~HTML
      {{ section.content | safe }}
    HTML

    cd testpath/"mysite" do
      system bin/"zola", "build"
    end

    assert_equal "<p>Hi I'm Homebrew.</p>",
      (testpath/"mysite/public/blog/index.html").read.strip
  end
end
