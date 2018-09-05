class Warp < Formula
  desc "Secure terminal sharing with one simple command"
  homepage "https://github.com/spolu/warp"
  url "https://github.com/spolu/warp/archive/v0.0.3.tar.gz"
  sha256 "9079899099b63ee470e693b7f2723cbf8d75cafe880b4329cf9f516c2669e8ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d48b2519458f997d8591c1f3bc645e9877486b95849656651865376450bf2d0" => :mojave
    sha256 "214fdbd64070317a1a5026b54a590d1783c295ac7240ac442092314ab861a252" => :high_sierra
    sha256 "562aed9e482aa4423476a0a83e9ecb36822ac19968f4440362a3b273bdcaf4dc" => :sierra
    sha256 "cc33305d446538db611f039f585648afed84268b1c98fc9a0c5ded76185eee0e" => :el_capitan
    sha256 "7bad4e1c81ee20c9908e7317bf8d8b71c807df95355e1e232ac055769b56a9c4" => :yosemite
  end

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
