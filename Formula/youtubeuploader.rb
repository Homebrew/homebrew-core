class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://github.com/porjo/youtubeuploader/archive/22.01.tar.gz"
  sha256 "22f9a1a65b442b6e3aedccab2480e80c6c5e44175deb0e2a9e872a1d32d9cc15"
  license "Apache-2.0"
  head "https://github.com/porjo/youtubeuploader.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07f5fd2bbd8b8044a7d4af363dc2f1552788492acdcd168c27a4e61229219d2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6144153ac8cbe5fc8a93639edc3aca080a7d8e52af62f47d17ac148a0044098"
    sha256 cellar: :any_skip_relocation, monterey:       "bc317e56e9574fbcd88221fea1a7ef2e99fff3cbef0b04466fe054ee947e443b"
    sha256 cellar: :any_skip_relocation, big_sur:        "16453ad4d17a6b2cd82df8a8343275e015d24b9cfee71cf06596cc7883eb1476"
    sha256 cellar: :any_skip_relocation, catalina:       "a9cfd69ce29480574c4eb1f8d35e7cfdde6e74294179769e6562039a1e0dbb64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40be54af44494434c2ca6854b81e62fafaed052ddaef7634f37856961104e5b2"
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
