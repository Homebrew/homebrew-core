class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/cli"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.38.6/v2.38.6.tar.gz"
  sha256 "22a19a8ee4791f57aec7f2ac3eb497575632c519e94bbd77d0ee67a1e95afc2c"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2df4534c78f9d0e1852ed4ffe5c6a817435c830366178fa9236101b92636d24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2df4534c78f9d0e1852ed4ffe5c6a817435c830366178fa9236101b92636d24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2df4534c78f9d0e1852ed4ffe5c6a817435c830366178fa9236101b92636d24"
    sha256 cellar: :any_skip_relocation, sonoma:        "25a2ecef3ac866295c5386bfea61ae9446b2e5e13dc353832ce1262792778274"
    sha256 cellar: :any_skip_relocation, ventura:       "25a2ecef3ac866295c5386bfea61ae9446b2e5e13dc353832ce1262792778274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c4090c96da50c73cd4f8f2fc0581d99feace82548d12886263efeb920bd92a3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: libexec/"spicetify")
    cd buildpath do
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

    output = shell_output("#{bin}/spicetify config current_theme 2>&1", 1)
    assert_match "com.spotify.Client is not a valid path", output
  end
end
