class Trurl < Formula
  desc "Command-line tool for URL parsing and manipulation"
  homepage "https://curl.se/trurl/"
  url "https://github.com/curl/trurl/releases/download/trurl-0.16/trurl-0.16.tar.gz"
  sha256 "2c26e3016f591f06234838bbe1dd4b165dce2c871c82ca6a32222d19696588d6"
  license "curl"
  head "https://github.com/curl/trurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df26d62384190d1a00053a96ba375a141c425bb2a0f0cada3fc31f85c4168486"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b58119bdf75c5a16c8fdecc4dfac11b5e0a2c52f98572c4504f3ace89ba0eebe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03f8e7f616a696ad50626c1ac19fca6c621a938949ddc015f9e5f30a7c3a940e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3ea260353a4fedd1c00eed276c199209113fdd4cb45e7765ae86c91072ebd8c"
    sha256 cellar: :any_skip_relocation, ventura:       "95e22717c9655e8c099e7c71bea14e012ee92374e4cdea6f91790801abe39e3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77c225dfb01348c5cd528fe01f6fe93c081a91b24225dad218c8372a2a8944c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dee373d99cf5010d37ca908c283018c8ea0265a809c368ccaf8bcd7aae12302"
  end

  uses_from_macos "curl", since: :ventura # uses CURLUE_NO_ZONEID, available since curl 7.81.0

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/trurl https://example.com/hello.html " \
                          "--default-port --get '{scheme} {port} {path}'").chomp
    assert_equal "https 443 /hello.html", output
  end
end
