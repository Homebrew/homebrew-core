class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://github.com/porjo/youtubeuploader/archive/22.02.tar.gz"
  sha256 "56f586277935c99c33512234ece24b763a9f7b417bc1cfddd601945365058b58"
  license "Apache-2.0"
  head "https://github.com/porjo/youtubeuploader.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ba8ca719866091a696b942f55e488c4962470f24502f48154f302b4c352a490"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71f1e8ad1382105e54528d21e7e163c09fa1a4298f86e5980a7ec45b5cc70132"
    sha256 cellar: :any_skip_relocation, monterey:       "54819745c9d22d5d8619137a29a14ec4e51abc72338daa25ce4906ed45475da6"
    sha256 cellar: :any_skip_relocation, big_sur:        "2103c3cfd9fee6ad17fe82de4badf9e9460cda5741359e61fd59880975d3cc5c"
    sha256 cellar: :any_skip_relocation, catalina:       "2275c70931257b1cdf56181ea5ba7ac4078ed91ad22b3c8435aaf7160826bc38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "316e30ac7cbb2004c08aad54869776a000f4891e91d917f04cba0115b85f8431"
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
