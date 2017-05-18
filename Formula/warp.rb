class Warp < Formula
  desc "Secure terminal sharing with one simple command"
  homepage "https://github.com/spolu/warp"
  url "https://github.com/spolu/warp/archive/v0.0.3.tar.gz"
  sha256 "9079899099b63ee470e693b7f2723cbf8d75cafe880b4329cf9f516c2669e8ca"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/spolu/"
    ln_sf buildpath, buildpath/"src/github.com/spolu/warp"

    system "go", "build", "-o", "#{bin}/warp", "github.com/spolu/warp/client/cmd/warp"
  end

  test do
    rand_id = (0...16).map { ("a".."z").to_a[rand(26)] }.join
    out = shell_output("#{bin}/warp connect test-#{rand_id}")

    assert_match /Connected to warp:/, out
    assert_match /(Received warp_unknown|Not running in a terminal)/, out
  end
end
