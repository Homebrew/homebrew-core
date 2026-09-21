class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.45.1/v2.45.1.tar.gz"
  sha256 "b20a6aa0e2e54491fb4b39a2329a793ec745a068071c4a1644cae61a4307cfa1"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "18fcce5d653491248905379f4a6680f01fe1c2c4f82497b6cce146ad5447a2cd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "18fcce5d653491248905379f4a6680f01fe1c2c4f82497b6cce146ad5447a2cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "18fcce5d653491248905379f4a6680f01fe1c2c4f82497b6cce146ad5447a2cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2537f46f84cd3685be252a45372a063e4aa0c6bca77f10434958b058b50fbf2c"
    sha256 cellar: :any,                 x86_64_linux:      "1c9bbbd95cf36294233e66392bf7ec86fa8da873adf4d4189b2afef76c971ebb"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
    system "pnpm", "with", "current", "install", "--frozen-lockfile"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: libexec/"spicetify")

    system "pnpm", "--offline", "with", "current", "run", "build:wrapper"

    libexec.install [
      "css-map.json",
      "CustomApps",
      "Extensions",
      "globals.d.ts",
      "jsHelper",
      "Themes",
    ]
    bin.install_symlink libexec/"spicetify"
  end

  test do
    spotify_folder = testpath/"com.spotify.Client"
    pref_file = spotify_folder/"com.spotify.client.plist"
    mkdir_p spotify_folder
    touch pref_file

    path = testpath/".config/spicetify/config-xpui.ini"
    path.write <<~INI
      [Setting]
      spotify_path            = #{spotify_folder}
      current_theme           = SpicetifyDefault
      prefs_path              = #{pref_file}
    INI

    quiet_system bin/"spicetify", "config"
    assert_match version.to_s, shell_output("#{bin}/spicetify -v")

    output = shell_output("#{bin}/spicetify config current_theme")
    assert_match "SpicetifyDefault", output
  end
end
