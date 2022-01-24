class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v8.2.0.tar.gz"
  sha256 "54fe60ef70b21b34c50c0d342ec120aff3a9522ef44a9737f42d5700aed7a1c3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4004a5e335073ca546024bb1f94e2537ff6a08e8093569f9b641ccfe5d21e96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "423afd7f664fbc3bc1ae1e8a37ef95aaaddf319f367fdf86e7ac9a3ef7538850"
    sha256 cellar: :any_skip_relocation, monterey:       "4bbb5fefb404ca2a39e06819913f019dde67e6de75f1c1b749158a2886d2f7dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cc8a044174db649284c0d04fd9673f91c43dc99c3e20ec7b80e8790e798f3d6"
    sha256 cellar: :any_skip_relocation, catalina:       "225f33e5195378987773ac83dff3d689ef8d6e3647896ddc8cfd35e2b33d24ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "264ead537ab66acfb2c401b4f9de6ddbd0b253b3806c52f46bf4e7ed30dc0d90"
  end

  depends_on "rust" => :build
  depends_on xcode: :build if MacOS::CLT.version >= "11.4" # libxml2 module bug

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Configuration path details: https://github.com/r-darwish/topgrade/blob/HEAD/README.md#configuration-path
    # Sample config file: https://github.com/r-darwish/topgrade/blob/HEAD/config.example.toml
    (testpath/"Library/Preferences/topgrade.toml").write <<~EOS
      # Additional git repositories to pull
      #git_repos = [
      #    "~/src/*/",
      #    "~/.config/something"
      #]
    EOS

    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew_formula")
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}/bin/)?brew upgrade}o, output
    refute_match(/\sSelf update\s/, output)
  end
end
