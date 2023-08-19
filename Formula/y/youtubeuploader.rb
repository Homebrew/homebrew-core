class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://github.com/porjo/youtubeuploader/archive/23.02.tar.gz"
  sha256 "48f4315c713581547cd90b399c51a98f7d8a79c698f9a1f19f8a0d3dc70bd814"
  license "Apache-2.0"
  head "https://github.com/porjo/youtubeuploader.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07b89e4ed8ee773dde84b81772471e48ee910d291989d577136c0368cc34f67f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07b89e4ed8ee773dde84b81772471e48ee910d291989d577136c0368cc34f67f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07b89e4ed8ee773dde84b81772471e48ee910d291989d577136c0368cc34f67f"
    sha256 cellar: :any_skip_relocation, ventura:        "a24e908a50675105dd26c9392e9f02f639555c1f00588e450646159279b234c0"
    sha256 cellar: :any_skip_relocation, monterey:       "a24e908a50675105dd26c9392e9f02f639555c1f00588e450646159279b234c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a24e908a50675105dd26c9392e9f02f639555c1f00588e450646159279b234c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdb69cdbb2b5e68d63cc9a4234b01cf2ee89f2d2da18a4df1c5b28268e46e29e"
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
