class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.46.7/v2.46.7.tar.gz"
  sha256 "b6609b1f62cd2ee6bd8a6c4512d010f9ef041a219ae615cfa1d2c0904bb74729"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7dee450489dfc14a09aafef1644d1701868c7d2a60d6d36dd9371704383927ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7dee450489dfc14a09aafef1644d1701868c7d2a60d6d36dd9371704383927ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7dee450489dfc14a09aafef1644d1701868c7d2a60d6d36dd9371704383927ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "af3835960ae82c1660f8563fc76265368a9ac0517c4e330e2cf2da4cf3850e40"
    sha256 cellar: :any,                 x86_64_linux:      "7333d0dd3ec1ee4301ee5ca9ee661506da2d61182ddc35eeef2f1a9df83c50dd"
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
