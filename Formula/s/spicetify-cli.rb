class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/spicetify-cli"
  url "https://github.com/spicetify/spicetify-cli/archive/refs/tags/v2.36.13/v2.36.13.tar.gz"
  sha256 "4af9a7677178adaca6cb74e34c5332db050d11aa85a92e020329a718517bf7c5"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/spicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "484adf0609e89bf0aba5d67ef8c67fcfee5509c13601c8479cdd0500c8d910d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df6df8f85a9c4ed6c83a2644d7bedc2e856d09fe5c396d084bbd381f590f0c69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68529a79b552b8562ead1de044559122d2ce5a686892876a90acf487c1530ecb"
    sha256 cellar: :any_skip_relocation, sonoma:         "3adad16bca520a4d54178f5df0895953363d78b7bb4cd08c0637bcafacfafcc9"
    sha256 cellar: :any_skip_relocation, ventura:        "22dd09f002cd4f19f070e263668f6f6d6151ae5a4c314fdfb16018f43690a6d3"
    sha256 cellar: :any_skip_relocation, monterey:       "50826a7dee1da62a6b26d49a14e43edfccd6747156b2eae2c1a2b7446d9fc5d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d65a07b401a03bd8748ed94a526402a02606a946e706c62672558cccc27728c3"
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
