class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.1.0.tar.gz"
  sha256 "b6ea521ce3bbd0f55d0f8b61181312bb23a4da6d3605fe449d080abeffe09d91"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ef608bc19d4f7b73774a664163c8b134d5110203dee5008a513d60704cbb68f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d940db79ce543334b7d888033adc22a517ed37b607bc2e1d0a37d2831ef26608"
    sha256 cellar: :any_skip_relocation, monterey:       "9d5648c31c7dba7867ad7a9915a54ad67342eb96b8347e8e6bf834606ec9d38c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a94e918e25975679aac042648547d882887b52e2f67c2271d1a6f63011043716"
    sha256 cellar: :any_skip_relocation, catalina:       "ec79048231822f03c6dc5be241f215c650ef148036292e3be6e1fd6000d92325"
  end

  depends_on xcode: ["11.2", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Weaver uses Sourcekitten and thus, has the same sandbox issues.
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/weaver", "version"
  end
end
