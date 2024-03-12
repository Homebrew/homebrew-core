class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/spicetify-cli"
  url "https://github.com/spicetify/spicetify-cli/archive/refs/tags/v2.34.0/v2.34.0.tar.gz"
  sha256 "001839b05402a072a681e2e50a4bae1c681a7ebd72b37439f9ed398c265d179d"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/spicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "442a0708615251943599c7944a6d4d386dbfd3eeca07bf11bab9c3a4ea544926"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7348626892933e55dd72e50d0cec8e9f4a7cecb8495e4590da553af640bf8d6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e164f4660742ccea68e3d4be1bfe18aa1ebffe06d43dd777a39cd98bb2797355"
    sha256 cellar: :any_skip_relocation, sonoma:         "0028b8a96c1f592a8e94edd152e3649c0a5e5203a99fe2a2f2532854671a85af"
    sha256 cellar: :any_skip_relocation, ventura:        "be5f54d090ea9ba3b41e1674c47f70a9c509531209cac66d7feba71065a3167e"
    sha256 cellar: :any_skip_relocation, monterey:       "fc61628be12ae7352af4d55e15adb1ec47dda460a2d95fdf88dd89974ec1c74b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7561c11a60cb92ae89bd289f0d354c9a3f5a08dcb56ad6e3fdd173fe127b0bc2"
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
