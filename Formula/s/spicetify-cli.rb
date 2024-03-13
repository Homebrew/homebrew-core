class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/spicetify-cli"
  url "https://github.com/spicetify/spicetify-cli/archive/refs/tags/v2.34.1/v2.34.1.tar.gz"
  sha256 "13f8582cc5aa3ec3d2b89d41d3241628ed65dd0c2b090d7572c7594d3b220c7a"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/spicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f406c02302f70735772a986f82b292804ac4ca89fe5a380da1e73792fe6503d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a502415c0070849bad4f25854ea202957b0cefca637a2351776e0d4863736510"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "056e6895793dd57eec4656f3024b90ecb1c147d5ac2a0541490f1f6d7c47367b"
    sha256 cellar: :any_skip_relocation, sonoma:         "aaed60bd7853057de3b0b12780d3564ddf412027a0d58080a63bb6c22c84b591"
    sha256 cellar: :any_skip_relocation, ventura:        "da6e65e1e9faca852953c195d9a1cfe39d83a8982fe4b7c3c178eeb99c24d529"
    sha256 cellar: :any_skip_relocation, monterey:       "6a7ec5b525a8e2f8c1d386f06c79ae22c2af932f4e0a6d8294fadbca2f24f90e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "519176ba41cb99bcc984497d05edc06d85d2904fbea18e2d366a3069b6df8e2d"
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
