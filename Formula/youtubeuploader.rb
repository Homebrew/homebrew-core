class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://github.com/porjo/youtubeuploader/archive/22.04.tar.gz"
  sha256 "46c8089d95c0156d3d90310b8679eed8569862122e8d23b9ca5ce1229639dbd9"
  license "Apache-2.0"
  head "https://github.com/porjo/youtubeuploader.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30f7e5ae721da535e957767a5d90effea1207f7bb33088afbc71916ccce644f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6c646d0777513146dbbd385475135e75d79c0db8ea65ab1b19efd83caa774f1"
    sha256 cellar: :any_skip_relocation, monterey:       "b1b3411312848def235b2bcb7621947f50954f95d126f32a7b61d2dcbceacc4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8e7b4db1c565158b547a534fe783bbe4b520b68cab78f030d9c51cb94bba794"
    sha256 cellar: :any_skip_relocation, catalina:       "9ec6d96d62ba3740c636d633b1caee6a7d7717c7a60e0642e1351991cdbed98a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c7ffcc51bebef2de4747bd1a328bfb9bb0b05f40f36da7af712fb22af8916f7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -X main.appVersion=#{version}")
  end

  test do
    # Version
    assert_match version.to_s, shell_output("#{bin}/youtubeuploader -version")

    # OAuth
    (testpath/"client_secrets.json").write <<~EOS
      {
        "installed": {
          "client_id": "foo_client_id",
          "client_secret": "foo_client_secret",
          "redirect_uris": [
            "http://localhost:8080/oauth2callback",
            "https://localhost:8080/oauth2callback"
           ],
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://accounts.google.com/o/oauth2/token"
        }
      }
    EOS

    (testpath/"request.token").write <<~EOS
      {
        "access_token": "test",
        "token_type": "Bearer",
        "refresh_token": "test",
        "expiry": "2020-01-01T00:00:00.000000+00:00"
      }
    EOS

    output = shell_output("#{bin}/youtubeuploader -filename #{test_fixtures("test.m4a")} 2>&1", 1)
    assert_match "oauth2: cannot fetch token: 401 Unauthorized", output.strip
  end
end
