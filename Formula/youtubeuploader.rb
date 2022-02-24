class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://github.com/porjo/youtubeuploader/archive/21.07.tar.gz"
  sha256 "ca3f43fc9921370ee70d35c5d0a5bd2d7258dcdb5d41660bde7539d8a6839b26"
  license "Apache-2.0"
  head "https://github.com/porjo/youtubeuploader.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1931eb72da137173d72cbda46b18c58e42afa23a32dbaec5e8c759aa186e13e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c0ac49032fec510c75a81e89fdcdee398aea5bcd6b0e5fa298cf171339e1cce"
    sha256 cellar: :any_skip_relocation, monterey:       "151459821f39c89ea63b3f521adbe096535bb52562af2c5fe03b8537a7efc5c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "46ad156b3a52e7da02e4c8292a0d3e9347696ea63167d1b960e8da490925e453"
    sha256 cellar: :any_skip_relocation, catalina:       "96377a82a1904ffd47b7a8d91eec7a6138649f75bd3bb086fe0b177ef0ea2403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbce5c73438e514b21186d6751f7df3e8e62076b2ea9b17a0e264fd758eba4bd"
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
