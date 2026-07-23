class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.44.0/v2.44.0.tar.gz"
  sha256 "aafdfceeae5ff926ffe27bf3808cd4228e3a2725f7f3539531f4f5c0ac98962d"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5e3ac3dddee5a8cf47fbecc45ad7ba67e2dfb5870131c63b35a159b74087a34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5e3ac3dddee5a8cf47fbecc45ad7ba67e2dfb5870131c63b35a159b74087a34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5e3ac3dddee5a8cf47fbecc45ad7ba67e2dfb5870131c63b35a159b74087a34"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d55eff227a058202b96d673c7814aae9386594db3de6da875ab51497b664987"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9496a44e7a97861a41e26121b3dddd03b11dfe7381bb78c8d3cf0aa8fd965df3"
    sha256 cellar: :any,                 x86_64_linux:  "0709541332b4ed3092ba6562ca0b6991f5ce510b110c5a7ac8e7e317128da3d3"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: libexec/"spicetify")

    system "pnpm", "with", "current", "install", "--frozen-lockfile"
    system "pnpm", "with", "current", "run", "build:wrapper"

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
