class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/spicetify-cli"
  url "https://github.com/spicetify/spicetify-cli/archive/refs/tags/v2.36.11/v2.36.11.tar.gz"
  sha256 "a43c918d07a14a87f01947399be927e48c8e2afa0f1da504329d8769858c06f6"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/spicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31a8d5d22301188d711560bf7eb316d0b28e65dd84adedc59169e883adc894f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68dce90c5ca14d38305e6e417e7c6d814cf3a3a5f3d608d131c5fd61612e394d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7970f248ab64cae03fb76d31f828a43eba78598c97971a28870d17c64306cfba"
    sha256 cellar: :any_skip_relocation, sonoma:         "9174ca6dbbd6f739f719be4b6f54fae9099645f32d66f5dda0356c632bbb1336"
    sha256 cellar: :any_skip_relocation, ventura:        "e0d1f765950aaa169fdc0f6d6c3366f162cdb0322dae1ddcc236f6b3f8b5f3b9"
    sha256 cellar: :any_skip_relocation, monterey:       "1147a8c217efaf7398f3acc75e59602335056af3d6b4445ee878cecea3bb3dd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "990227dcc5e321181c9648804a435d0c827a7f367c7204554ffe9a1edd33f645"
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
    path.write <<~EOS
      [Setting]
      spotify_path            = #{spotify_folder}
      current_theme           = SpicetifyDefault
      prefs_path              = #{pref_file}
    EOS
    quiet_system bin/"spicetify", "config"
    assert_match version.to_s, shell_output("#{bin}/spicetify -v")
    assert_match "SpicetifyDefault", shell_output("#{bin}/spicetify config current_theme")
  end
end
