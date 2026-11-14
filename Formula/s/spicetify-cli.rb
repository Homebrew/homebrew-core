class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.46.7/v2.46.7.tar.gz"
  sha256 "b6609b1f62cd2ee6bd8a6c4512d010f9ef041a219ae615cfa1d2c0904bb74729"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "15bd0484c3df698312d90bba9185060f9a745cc2ce996a58033e5d36f09864bb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "15bd0484c3df698312d90bba9185060f9a745cc2ce996a58033e5d36f09864bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "15bd0484c3df698312d90bba9185060f9a745cc2ce996a58033e5d36f09864bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "43b9b939cc41c48aa6d5b9e09a8c0d83835a325cfb6ad91f60fb0d0675eae682"
    sha256 cellar: :any,                 x86_64_linux:      "22e57d09702b9c11983f9f776cccd4cd0b540ae93b9685bca4b3283e5dc3ee40"
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
