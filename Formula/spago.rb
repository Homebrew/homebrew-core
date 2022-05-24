class Spago < Formula
  desc "PureScript package manager and build tool"
  homepage "https://github.com/purescript/spago"
  url "https://github.com/purescript/spago/archive/refs/tags/0.20.9.tar.gz"
  sha256 "4e0ac70ce37a9bb7679ef280e62b61b21c9ff66e0ba335d9dae540dcde364c39"
  license "BSD-3-Clause"
  head "https://github.com/purescript/spago.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e0bdbfd6c263b7887da4f8031a5c6263b7bd2345bd50df31cbdecb9af3075ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b13c6566d9d4c40d34dfb9293fd39e3cf66ebb54e82999257a47475f0ade1ddd"
    sha256 cellar: :any_skip_relocation, monterey:       "a3d4cf0264b4fea348f09122552279ac9515bff3003d7fcb01808d465da89f8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "771754939dc4374b84a3cd39214a3b0749e665d590a736f397cf91657d48a8be"
    sha256 cellar: :any_skip_relocation, catalina:       "9dbe38aaceb447ea90a4aeb7911f3111e60f18f84729af89b5a6e431acd13738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8bee7f77a2ab534fc5c83201fe3ba287a2581be9a7470baed0dd4e870ad7670"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build
  depends_on "purescript"

  # Check the `scripts/fetch-templates` file for appropriate resource versions.
  resource "docs-search-app-0.0.10.js" do
    url "https://github.com/purescript/purescript-docs-search/releases/download/v0.0.10/docs-search-app.js"
    sha256 "45dd227a2139e965bedc33417a895ec7cb267ae4a2c314e6071924d19380aa54"
  end

  resource "docs-search-app-0.0.11.js" do
    url "https://github.com/purescript/purescript-docs-search/releases/download/v0.0.11/docs-search-app.js"
    sha256 "0254c9bd09924352f1571642bf0da588aa9bdb1f343f16d464263dd79b7e169f"
  end

  resource "purescript-docs-search-0.0.10" do
    url "https://github.com/purescript/purescript-docs-search/releases/download/v0.0.10/purescript-docs-search"
    sha256 "437ac8b15cf12c4f584736a07560ffd13f4440cd0c44c3a6f7a29248a1ff8171"
  end

  resource "purescript-docs-search-0.0.11" do
    url "https://github.com/purescript/purescript-docs-search/releases/download/v0.0.11/purescript-docs-search"
    sha256 "06dfcb9b84408527a2980802108fae6a5260a522013f67d0ef7e83946abe4dc2"
  end

  def install
    # Equivalent to make fetch-templates:
    resources.each do |r|
      r.stage do
        template = Pathname.pwd.children.first
        (buildpath/"templates").install template.to_s => "#{template.basename(".js")}-#{r.version}#{template.extname}"
      end
    end

    system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"
    (bash_completion/"spago").write `#{bin}/spago --bash-completion-script #{bin}/spago`
    (zsh_completion/"_spago").write `#{bin}/spago --zsh-completion-script #{bin}/spago`
  end

  test do
    system bin/"spago", "init"
    assert_predicate testpath/"packages.dhall", :exist?
    assert_predicate testpath/"spago.dhall", :exist?
    assert_predicate testpath/"src"/"Main.purs", :exist?
    system bin/"spago", "build"
    assert_predicate testpath/"output"/"Main"/"index.js", :exist?
  end
end
