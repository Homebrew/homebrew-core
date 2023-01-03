class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://github.com/porjo/youtubeuploader/archive/23.01.tar.gz"
  sha256 "36d0f6e265fc7aeb8316ff91e1e638b34e695d046a5feffa7fc45fa121d995d9"
  license "Apache-2.0"
  head "https://github.com/porjo/youtubeuploader.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a169aa8860f1c40f5315cc36b97964780218835f7a85803dd3f3d1eb77bb1c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8621b71cb2cca01a787bb62c3353bf9e8a25c7f0c00d63d19af08fd4d97c2a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "107af1b7107a6f152bbc9997fa113ee0e5831fd74e74167fcea020c28ae2e16c"
    sha256 cellar: :any_skip_relocation, ventura:        "94cd7f73fc789291255a84f98487322c5dcbacec7b2d962604ff8ec7366d539b"
    sha256 cellar: :any_skip_relocation, monterey:       "55a340062308271103dff4382069b82e8d57cbbf1c1e7103b23ac9fdc013d6ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac1c4985db261e8497bdcaeb0d5d29c50e3ca5e706825d96abf9dea5e60336ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "533bf7e586d57fa46aa519e2dc56aa3ccd53e4b5ed05654cb4e971dd4a6f5d64"
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
