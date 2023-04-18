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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6447a607985494aed97909b0583f6d82d280adb3e739e0c0cb3c427fe1c1c86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea6c1ae274ae86a19b1b5e476a01cf3cff396dcca7bf0a004b931767bb29d5b4"
    sha256 cellar: :any_skip_relocation, ventura:        "c97e12c317c389b7279a4b4f173b8c521ece15da4c1fca3ca6cba63bbd6768f5"
    sha256 cellar: :any_skip_relocation, monterey:       "e8974b1ff24ce317a5c94a225b669d0d7c7e35dbf2df1a27c9b29ff1d60854be"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5fa3a596084f77f2c4504afab744fe8ab18eef868353196c512af1991d9366a"
    sha256 cellar: :any_skip_relocation, catalina:       "316fc107f6b9ced5eed8f3fd8cf08bd73f9f03818bad293fed3568516d76b63f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ae695f9eb22eef6a1b98a56c87400cd52fda8d91b00da354e59c4f1b47b3e16"
  end

  depends_on "ghc@8.10" => :build
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
