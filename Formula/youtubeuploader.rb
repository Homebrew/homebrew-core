class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://github.com/porjo/youtubeuploader/archive/22.01.tar.gz"
  sha256 "22f9a1a65b442b6e3aedccab2480e80c6c5e44175deb0e2a9e872a1d32d9cc15"
  license "Apache-2.0"
  head "https://github.com/porjo/youtubeuploader.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "972962a201437a846865d4bde12cec996fb745e3835f7dcff8623b3d1b35b4fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "129576801b3853139bb03a0307791c08a0c1d5cd6a7fd1a0dbaf2cc67ad6a3e6"
    sha256 cellar: :any_skip_relocation, monterey:       "0f5b97069e9dc2a021f0ca14c95f8268159b20f2e1b895821ded69410c12ca64"
    sha256 cellar: :any_skip_relocation, big_sur:        "868a23ca43b57913f2a5b4a3b23d9e6ee2982c420caac598d74aca20f7e58bc4"
    sha256 cellar: :any_skip_relocation, catalina:       "e89ac10dde0976e1206b2a04aa51b879df241ac4a0131186b14ca34dab90abab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36133b5d918ed4905e7ee628cc9cdbfa1b02a8d93599bf702e81f5f83e1c97fb"
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
