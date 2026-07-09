class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.44.0/v2.44.0.tar.gz"
  sha256 "aafdfceeae5ff926ffe27bf3808cd4228e3a2725f7f3539531f4f5c0ac98962d"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c531c87019010d9e7e7a6559678df85e00fe3ac8d874cab13cc5e23b1539ea9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c531c87019010d9e7e7a6559678df85e00fe3ac8d874cab13cc5e23b1539ea9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c531c87019010d9e7e7a6559678df85e00fe3ac8d874cab13cc5e23b1539ea9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a178d6b42c64aefd7f7bc03d4fe69ba1364a367282701c76a8824a213f5a844"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f42382bf40a044b5f729c242ea637235f4a23c77e9e40cf07d2b739a82c2a99a"
    sha256 cellar: :any,                 x86_64_linux:  "5d99faf6a19e59ccf43e1deba8efb24f8dbf2a41fcc8a39201318ab29794c963"
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

    output = shell_output("#{bin}/spicetify config current_theme")
    assert_match "SpicetifyDefault", output
  end
end
