class Spago < Formula
  desc "PureScript package manager and build tool"
  homepage "https://github.com/purescript/spago"
  url "https://github.com/purescript/spago/archive/refs/tags/0.21.0.tar.gz"
  sha256 "0ae1b042010c4d1ffb3865ba0cf67beea741a40c724065dc4056367964b6f4ab"
  license "BSD-3-Clause"
  head "https://github.com/purescript/spago.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d5eab4b1fb90ac9d885b97b5babd968405a5d5de9e868646f9a999eda30ea46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1c516a357d01efcef8d2dc263ca4785c24b3e48559974925e8dfd985a672bf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ff1f1056aefbd2ea4e1ebc0a4415aefab0a21f09e0c90e6ddc0b5e732d75c79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0765e9b2ba05a82406efa85966071307b4021c95f6c5ad824a73f2911063856"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ae60344eaff53522d7e77d7962acccbfece42817364786718412edc50d2cadf"
    sha256 cellar: :any_skip_relocation, ventura:        "68fa6a6d91f5feee9201731301dbc041654266314ec842dfc4a8998db2d7f38e"
    sha256 cellar: :any_skip_relocation, monterey:       "cc9358258247e523961b0ebe1647c5559249ef65693ebff3c23fb0bf176f5edc"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f29c49a689127cf34f05f415d5c980eeea7e6b3c6e7b9df2214b5430f913f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa71b6e0cbd41ac5c0bb966030f1fe4ca2d1dbc11c19162a9407cd0d0d5d82ab"
  end

  depends_on "ghc@9.2" => :build
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
    generate_completions_from_executable(bin/"spago", "--bash-completion-script", bin/"spago",
                                         shells: [:bash], shell_parameter_format: :none)
    generate_completions_from_executable(bin/"spago", "--zsh-completion-script", bin/"spago",
                                         shells: [:zsh], shell_parameter_format: :none)
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
