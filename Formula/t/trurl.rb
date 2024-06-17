class Trurl < Formula
  desc "Command-line tool for URL parsing and manipulation"
  homepage "https://curl.se/trurl/"
  url "https://github.com/curl/trurl/archive/refs/tags/trurl-0.13.tar.gz"
  sha256 "8ceeb09d0e08dc677897f26651aa625d9ad18021f881f9d5f31e5a95bb3cc047"
  license "curl"
  head "https://github.com/curl/trurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95e36b9a03b5ee61af2dc17af55c6c2ad064be8818ec6ed998b079566d536147"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7261e09b105ee7387f49196856db5857cdbff45df911631c46aac52eceeb6462"
    sha256 cellar: :any,                 arm64_monterey: "454627fe59d53d3bcddfd8c5a091acb7f10a3a02e3de52ab786e55657b4981ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ee985d9f93f6cbe0c9c782f78b4564a92f333c9252e0f858a474a0567f328e4"
    sha256 cellar: :any_skip_relocation, ventura:        "9077c830acfacda9026c53611378f4aab93ec34602fdbe2f8c1b0780b30900b4"
    sha256 cellar: :any,                 monterey:       "bbc2bfbd4ac12e8dda47a0aeedb0004c09813638e113ea62ed39bfc0b140db25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c6086dd1ed109c8b3f86cd362555c8981ad74f148a2760a3a3f47b61d2f1b96"
  end

  uses_from_macos "curl", since: :ventura # uses CURLUE_NO_ZONEID, available since curl 7.81.0

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output(bin/"trurl https://example.com/hello.html " \
                              "--default-port --get '{scheme} {port} {path}'").chomp
    assert_equal "https 443 /hello.html", output
  end
end
