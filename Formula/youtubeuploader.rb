class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://github.com/porjo/youtubeuploader/archive/21.05.tar.gz"
  sha256 "cc087e05e9a31408a6941030cdb933e6e52d619960e765dbb3d91e3661d3dc98"
  license "Apache-2.0"
  head "https://github.com/porjo/youtubeuploader.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0ea51dc13d1145f8a9aa71cd4c830e16d50d71afcb15803764f89c4e1beb09d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9c2a99f7217b0f608839664fe211648eddba109a8abd6a856996da21d57e4a0"
    sha256 cellar: :any_skip_relocation, monterey:       "636f0f3a290cc1d93a548479c2913d288aa4aae2678bc90afb3e524c33fc0f14"
    sha256 cellar: :any_skip_relocation, big_sur:        "d91b78ca4c123e211e019c6fb1e2375bb4da1ae8c61a94758c2ff2b1f8e20acf"
    sha256 cellar: :any_skip_relocation, catalina:       "ee0a39a9643a8d5061fa8335c88b702ee030b60a97b86ea154adc2b455b437f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb64847bd8bc39c75aa6d867e8f96c3679c48fab05970b30b43c1e230dcabd75"
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
