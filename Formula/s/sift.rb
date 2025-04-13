class Sift < Formula
  desc "Fast and powerful open source alternative to grep"
  homepage "https://sift-tool.org/"
  url "https://github.com/svent/sift/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "bbbd5c472c36b78896cd7ae673749d3943621a6d5523d47973ed2fc6800ae4c8"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a9f002da076b35a37e62503ec58fe1ee19b6800f14467fdb6436de1dc648d9de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "677bc238dc0f303ab31800d2c3695539d2756365937c555a162b20a7c453da2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80ae5c278ab9dcb654474a7a2f0306dc5d96d4de01e73e96b69715aa48eeaad8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbc851806c100acc052be58ce103f0b2b5304a79e22a1331f6541f4f37b88ef9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4d9aa5a4b8c3f188da9966e82d1aee1bae3c530a2180d2fa5a667ce314d00a4"
    sha256 cellar: :any_skip_relocation, ventura:        "676602a4f1fd5a0a903b5094ce0b5e044ca5c2bce6967d680683e7c4a641478c"
    sha256 cellar: :any_skip_relocation, monterey:       "2bf9fe6ef94f951254079c5e6bed757526b4b8bf68e2eeb862fa07c71302a32d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a5dc83483b444b3850237050f761c8967ce36008114dad661a1424aa6068da3"
  end

  # https://github.com/svent/sift/issues/120
  deprecate! date: "2024-03-26", because: :unmaintained
  disable! date: "2025-03-26", because: :unmaintained

  depends_on "go" => :build

  resource "github.com/svent/go-flags" do
    url "https://github.com/svent/go-flags.git",
        revision: "4bcbad344f0318adaf7aabc16929701459009aa3"
  end

  resource "github.com/svent/go-nbreader" do
    url "https://github.com/svent/go-nbreader.git",
        revision: "7cef48da76dca6a496faa7fe63e39ed665cbd219"
  end

  resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        revision: "3c0d69f1777220f1a1d2ec373cb94a282f03eb42"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    (buildpath/"src/github.com/svent/sift").install buildpath.children
    resources.each { |r| (buildpath/"src"/r.name).install r }
    cd "src/github.com/svent/sift" do
      system "go", "build", "-o", bin/"sift"

      bash_completion.install "sift-completion.bash" => "sift"
    end
  end

  test do
    (testpath/"test.txt").write("where is foo\n")
    assert_match "where is foo", shell_output("#{bin}/sift foo #{testpath}")
  end
end
