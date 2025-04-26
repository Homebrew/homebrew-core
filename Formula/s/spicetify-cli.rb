class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.40.4/v2.40.4.tar.gz"
  sha256 "9a7216ab600a5c53b1b2351d6bb88df613d7c19570742f8deca978d900d90d5c"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "721efc62664ddf43b27207ce2918ec2a7aaf9d8a5c645a5bee08a8048f3d9b83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "721efc62664ddf43b27207ce2918ec2a7aaf9d8a5c645a5bee08a8048f3d9b83"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "721efc62664ddf43b27207ce2918ec2a7aaf9d8a5c645a5bee08a8048f3d9b83"
    sha256 cellar: :any_skip_relocation, sonoma:        "f32e7cf759c752e433a6efb242c9e41560968a8d947b86b7129e6535f9952b65"
    sha256 cellar: :any_skip_relocation, ventura:       "f32e7cf759c752e433a6efb242c9e41560968a8d947b86b7129e6535f9952b65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f398d05d703fcf8b9f42c0cf43e83ab9a075186e7bc15cc881684ec4b14ec0b0"
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
