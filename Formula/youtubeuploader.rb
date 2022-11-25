class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://github.com/porjo/youtubeuploader/archive/22.06.tar.gz"
  sha256 "baf111cd99755b6ec17a694a3edf6fdf6886ffb606288451e6014de42bff3939"
  license "Apache-2.0"
  head "https://github.com/porjo/youtubeuploader.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a870022483bf4b3f493e5594c606c73542e9532de1cbb3360e3baff498b6e44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d05b0bde055295fac779352ad3239407ea77104728d051c810f33bee13794bdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "406a27d6c0a58b2837c841372dc8ec6645a384e6d2ce734cb668dfec1ad47685"
    sha256 cellar: :any_skip_relocation, ventura:        "69569746d54d2d6939b4cf000d587862ffff7d05a87436d99ba937e4547dbe74"
    sha256 cellar: :any_skip_relocation, monterey:       "b02ffa02fb0b1042ecd656a22d16427fb6d22d5603905d9e7df5b06b8dfe746a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea7f5b67f09eab0a4d9ff32fc6e64a9987e0a9e28479693189d53e3a290830a2"
    sha256 cellar: :any_skip_relocation, catalina:       "33a1cd3cbf234e3586b9cfd6c4ee5c39137ce6c565209e4f181854a8e37bc672"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e7357282936af1ee6a447cc8e94a20e4723403f133fd70e3094d008e7208624"
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
