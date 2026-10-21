class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.46.2/v2.46.2.tar.gz"
  sha256 "f4251e342851d2a9edf01c3cee6a66501ee9a29c58b4adf79a0ca548b1044da5"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7af2e191ea8e27f75c0e356db89909c5e6d1c44b4d61e178457e5634b8b46f8f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7af2e191ea8e27f75c0e356db89909c5e6d1c44b4d61e178457e5634b8b46f8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7af2e191ea8e27f75c0e356db89909c5e6d1c44b4d61e178457e5634b8b46f8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5262ab32e10c9a9a37a6959b4a62e87918b75390a1c5340d92d67551c074660a"
    sha256 cellar: :any,                 x86_64_linux:      "de39d951f03bd12e0577410fe635e994c4cba94f1c19295574028870ad0cb076"
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
