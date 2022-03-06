class Spago < Formula
  desc "PureScript package manager and build tool"
  homepage "https://github.com/purescript/spago"
  url "https://github.com/purescript/spago/archive/refs/tags/0.20.7.tar.gz"
  sha256 "4bb73918813550d9841a8f50b5653f46253da12295d9d8038a63923044d7cf7c"
  license "BSD-3-Clause"
  head "https://github.com/purescript/spago.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb44856d548eff894648c7a5b2607776e5e90d3172c246343201e961b570c37c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33008a883792c326420f62b1ad8337f0f691a6303b59ca7ed7c47ce6327e7812"
    sha256 cellar: :any_skip_relocation, monterey:       "6cc31646a7ded4b9e7c8639d7e1b1b6d5cfcca60ac3e8b397c6ef01ca9f7cdd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "a468fd898e7455e430e67b9b8f02faa17e399c4e63540da05d34f731181eed1a"
    sha256 cellar: :any_skip_relocation, catalina:       "074392b06cc4595e17101045a49d42fbed166a943301cbb99d8ad2ac7f0e2262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54431b502b1be4d515c103912bb07c4c125a778afcbe838f5e6edaf5c8cba0a7"
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
