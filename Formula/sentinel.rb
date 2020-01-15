class Sentinel < Formula
  desc "Is a Policy as code framework for HashiCorp Enterprise Products"
  homepage "https://docs.hashicorp.com/sentinel/"

  SENTINEL_VERSION = "0.14.1".freeze
  SENTINEL_SHA256  = "8a6f714850fb30afac86cc73f653add96168d648fa3110072185fe2b5379e143".freeze

  url "https://releases.hashicorp.com/sentinel/#{SENTINEL_VERSION}/sentinel_#{SENTINEL_VERSION}_darwin_amd64.zip"
  sha256 SENTINEL_SHA256

  def install
    bin.install "sentinel"
  end

  test do
    # Check version matches
    system bin / "sentinel", "--version"

    # Check against basic policy
    # https://docs.hashicorp.com/sentinel/intro/getting-started/first-policy/#your-first-sentinel-policy
    (testpath / "pass.sentinel").write <<-EOS
      hour = 4
      main = rule { hour >= 0 and hour < 12 }
    EOS

    assert_equal "Pass\n", `sentinel apply pass.sentinel`
  end
end
